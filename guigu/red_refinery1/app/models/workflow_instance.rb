# frozen_string_literal: true

class WorkflowInstance < WorkflowCore::WorkflowInstance
  include EnumAttributeLocalizable

  belongs_to :tenant
  belongs_to :project

  has_many :observations, class_name: "WorkflowInstanceObservation", foreign_key: "instance_id"
  has_many :observable_members, through: :observations, source: :observable, source_type: "Member"
  has_many :observable_groups, through: :observations, source: :observable, source_type: "Group"

  belongs_to :creator, class_name: "Member"
  belongs_to :closed_by, polymorphic: true, optional: true

  after_create :auto_create_start_token!

  def terminate!(closed_by: nil)
    transaction do
      update! status: :terminated, closed_by: closed_by
      tokens.processing.update_all status: :terminated
    end
  end

  private

    def auto_create_start_token!
      tokens.create! assignable: creator,
                     place: workflow.start_place,
                     workflow: workflow,
                     type: "Token",
                     tenant: tenant, project: workflow.project
    end
end
