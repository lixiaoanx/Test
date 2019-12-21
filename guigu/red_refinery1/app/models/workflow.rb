# frozen_string_literal: true

class Workflow < WorkflowCore::Workflow
  include EnumAttributeLocalizable

  belongs_to :tenant
  belongs_to :project

  belongs_to :category, class_name: "WorkflowCategory", optional: true

  has_many :instance_observations, class_name: "WorkflowInstanceObservation"

  has_many :accessibilities, class_name: "WorkflowAccessibility"
  has_many :accessible_members, through: :accessibilities, source: :target, source_type: "Member"
  has_many :accessible_groups, through: :accessibilities, source: :target, source_type: "Group"

  has_many :visibilities, class_name: "WorkflowVisibility"
  has_many :visible_members, through: :visibilities, source: :target, source_type: "Member"
  has_many :visible_groups, through: :visibilities, source: :target, source_type: "Group"

  belongs_to :form
  belongs_to :origin_workflow, optional: true, class_name: "Workflow"
  has_many :versions, class_name: "Workflow", foreign_key: :origin_workflow_id

  has_one :start_place, class_name: "Places::StartPlace", dependent: :destroy

  scope :active, -> { where(state: :active) }

  scope :for, proc { |member|
    access_public
      .or(
        where(
          id: joins(:accessibilities)
                .where(workflow_accessibilities: { target_type: "Group" })
                .joins("left join groups on groups.id = workflow_accessibilities.target_id")
                .joins("left join member_groups on member_groups.group_id = workflow_accessibilities.target_id")
                .where(member_groups: { member_id: member.id })
                .access_whitelist
        )
      )
      .or(
        where(
          id: joins(:accessibilities)
                .where(workflow_accessibilities: { target_type: "Member" })
                .where(workflow_accessibilities: { target_id: member.id })
                .access_whitelist
        )
      )
      .distinct
  }

  scope :visible_for, proc { |member|
    visible_public
      .or(
        where(
          id: joins(:visibilities)
                .where(workflow_visibilities: { target_type: "Group" })
                .joins("left join groups on groups.id = workflow_visibilities.target_id")
                .joins("left join member_groups on member_groups.group_id = workflow_visibilities.target_id")
                .where(member_groups: { member_id: member.id })
                .visible_whitelist
        )
      )
      .or(
        where(
          id: joins(:visibilities)
                .where(workflow_visibilities: { target_type: "Member" })
                .where(workflow_visibilities: { target_id: member.id })
                .visible_whitelist
        )
      )
      .distinct
  }

  before_validation do
    self.tenant ||= project&.tenant
  end
  attr_reader :not_auto_start_place
  attr_writer :not_auto_start_place

  enum state: {
    active: 0,
    draft: 1,
    inactive: 2
  }

  enum accessibility: {
    public: 0, whitelist: 1
  }, _prefix: :access

  enum visibility: {
    public: 0, whitelist: 1
  }, _prefix: :visible

  after_create :auto_create_start_place!

  validates :title,
            presence: true

  # Graphviz::output(g, path: "test.pdf")
  def to_graph
    g = Graphviz::Graph.new # rankdir: "LR"
    start_place.append_to_graph(g, nodes: {})
  end

  def root_id
    if ow = self.origin_workflow
      ow.id
    else
      self.id
    end
  end

  def clone_with_transition_and_place
    wf = self.dup
    wf.origin_workflow_id = self.root_id
    wf.state = self.class.states[:draft]
    wf.not_auto_start_place = true
    Workflow.transaction do
      wf.save!
      mapping = self.transitions.map do |t|
        wf_t = t.dup
        wf_t.workflow = wf
        wf_t.save!
        [t.id, wf_t.id]
      end.to_h
      self.places.each do |p|
        wf_p = p.dup
        wf_p.workflow = wf
        wf_p.input_transition_id = mapping[wf_p.input_transition_id]
        wf_p.output_transition_id = mapping[wf_p.output_transition_id]
        wf_p.save!
      end
    end
    wf
  end

  def load_from_bpmn!(bpmn_xml)
    c = Bpmn::DefinitionContainer.parse(bpmn_xml)
    return unless c

    tokens.delete_all
    instance_observations.delete_all
    instances.delete_all

    transitions.destroy_all
    places.destroy_all

    place = create_start_place! type: "Places::StartPlace"
    node_queue = c.start_event.outgoing_ids

    convert_node_type = lambda do |node|
      case node.node_type
      when :task
        "Transitions::Sequence"
      when :user_task
        "Transitions::Sequence"
      when :start_event
        "Transitions::Start"
      when :end_event
        "Transitions::End"
      when :parallel_gateway
        node.outgoing_ids.size == 1 ? "Transitions::Synchronization" : "Transitions::ParallelSplit"
      when :exclusive_gateway
        node.outgoing_ids.size == 1 ? "Transitions::SimpleMerge" : "Transitions::ExclusiveChoice"
      else
        raise NotImplementedError, "#{node.node_type} doesn't support yet."
      end
    end

    transaction do
      loop do
        break if node_queue.blank?

        target_id = node_queue.pop
        curr_node = c[target_id]
        raise "#{target_id} not found!" unless curr_node

        # puts "1 #{curr_node.name} #{curr_node.node_type} from #{curr_node.try(:incoming_ids)&.join(", ") || curr_node.try(:source_id)} to #{curr_node.try(:outgoing_ids)&.join(", ") || curr_node.try(:target_id)}"

        if curr_node.flow?
          target_id = curr_node.target_id
          target = c[curr_node.target_id]
          raise "#{target_id} not found!" unless target

          target_transition = transitions.find_by uid: target.id
          transition = transitions.find_by uid: c[curr_node.source_id].id
          if transition && target_transition
            transition.output_places.create! output_transition: target_transition,
                                             type: "Place",
                                             workflow: self
            next
          elsif transition
            place = transition.output_places.create! type: "Place", workflow: self
          end

          curr_node = target
          # puts "2 #{curr_node.name} #{curr_node.node_type} from #{curr_node.try(:incoming_ids)&.join(", ") || curr_node.try(:source_id)} to #{curr_node.try(:outgoing_ids)&.join(", ") || curr_node.try(:target_id)}"
        end

        transition = transitions.find_by uid: c[curr_node.id].id
        transition ||= place.create_output_transition! title: curr_node.name, uid: curr_node.id,
                                                       type: convert_node_type.call(curr_node),
                                                       workflow: self

        dup_place = places.find_by input_transition_id: place.input_transition_id, output_transition_id: transition.id
        if dup_place
          place.destroy
          place = dup_place
        else
          place.update! output_transition: transition
        end

        children = curr_node.outgoing_ids - transitions.where(uid: curr_node.outgoing_ids).map(&:uid)
        if children.empty?
          transition.output_places.create! type: "Place",
                                           workflow: self
        end
        node_queue = children + node_queue
        # puts "===="
        # puts node_queue.join(", ")
        # puts "===="
      end

      places.where(output_transition: nil).update type: "Places::EndPlace"

      self
    end
  end

  # TODO: Remove in future
  def seed!
    tokens.delete_all
    instance_observations.delete_all
    instances.delete_all

    transitions.destroy_all
    places.destroy_all

    tmp_p = create_start_place! type: "Places::StartPlace",
                                title: "发起流程"

    # Fill form stage

    fill_form_t = tmp_p.create_output_transition! type: "Transitions::Variants::UserTask",
                                                  workflow: self,
                                                  title: "填写表单"
    tmp_p.update_attribute :output_transition_id, fill_form_t.id

    tmp_p = fill_form_t.output_places.create! type: "Place",
                                              workflow: self,
                                              title: "已填写表单"

    # Assign approvers and make approval stage

    tmp_t = tmp_p.create_output_transition! type: "Transitions::Variants::AssigningAssignees",
                                            workflow: self,
                                            title: "分配审批人"
    tmp_p.update_attribute :output_transition_id, tmp_t.id
    tmp_t.options.assign_to = "specific"
    tmp_t.save!

    tmp_p = tmp_t.output_places.create! type: "Place",
                                        workflow: self,
                                        title: "等待审批人审批"

    decision_t = tmp_p.create_output_transition! type: "Transitions::Variants::Decision",
                                                 workflow: self,
                                                 title: "审批人审批"
    tmp_p.update_attribute :output_transition_id, decision_t.id

    approved_p = decision_t.output_places.create! type: "Place",
                                                  workflow: self,
                                                  title: "同意"
    rejected_p = decision_t.output_places.create! type: "Place",
                                                  workflow: self,
                                                  title: "驳回"

    decision_t.options.pass_place_id = approved_p.id
    decision_t.options.veto_place_id = rejected_p.id
    decision_t.save!

    # Back to fill form stage if rejected

    tmp_t = rejected_p.create_output_transition! type: "Transitions::Variants::AssigningAssignees",
                                                 workflow: self,
                                                 title: "切换回申请人"
    rejected_p.update_attribute :output_transition_id, tmp_t.id

    tmp_t.output_places.create! type: "Place",
                                workflow: self,
                                title: "订正表单",
                                output_transition_id: fill_form_t.id


    # Optional sync to Redmine stage

    tmp_t = approved_p.create_output_transition! type: "Transitions::Variants::SyncToRedmine",
                                                 workflow: self,
                                                 title: "同步到 Redmine"
    approved_p.update_attribute :output_transition_id, tmp_t.id

    tmp_p = tmp_t.output_places.create! type: "Place",
                                        workflow: self,
                                        title: "已同步到 Redmine"

    # Adding observers

    tmp_t = tmp_p.create_output_transition! type: "Transitions::Variants::AddingObservers",
                                            workflow: self,
                                            title: "添加传阅人"
    tmp_p.update_attribute :output_transition_id, tmp_t.id

    tmp_p = tmp_t.output_places.create! type: "Place",
                                        workflow: self,
                                        title: "已添加传阅人"

    # Done

    tmp_t = tmp_p.create_output_transition! type: "Transitions::End",
                                            workflow: self,
                                            title: "流程结束"
    tmp_p.update_attribute :output_transition_id, tmp_t.id

    tmp_t.output_places.create! type: "Places::EndPlace",
                                workflow: self,
                                title: "流程结束"
  end

  private

    def auto_create_start_place!
      return if not_auto_start_place
      create_start_place!
    end
end
