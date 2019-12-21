# frozen_string_literal: true

module Projects::Workflows::Instances
  class TokensController < Projects::Workflows::Instances::ApplicationController
    before_action :set_token, only: %i[show fire forward endorse adding_observation]
    before_action :require_creator_or_observer!, only: %i[index]
    before_action :require_relevant_person!, only: %i[show fire forward endorse adding_observation]
    before_action :set_form_model, only: %i[show fire]

    def index
      @tokens = @instance.tokens.where(hidden: false, status: %w[processing completed]).includes(:forwardable, :assignable, :processable, :place).order(id: :asc)
    end

    def show
      @tokens = @instance.tokens.where(hidden: false, status: %w[processing completed]).includes(:forwardable, :assignable, :processable, :place).order(id: :asc)

      @transition_valid = @token.place.output_transition.options.valid?
      @form_record = @virtual_model.load(@instance.payload)

      @form_record.disable_attr_readonly!
      @form_record.assign_attributes(_decision: @token.payload.decision, _comment: @token.payload.comment, _action: @token.payload.action)
      @form_record.disable_attr_readonly!
    end

    def fire
      unless @token.processing?
        redirect_to project_workflow_instance_tokens_url(@project, @workflow, @instance)
        return
      end

      form_params = form_record_params
      @token.payload.comment = form_params[:_comment]
      @token.payload.action = form_params[:_action]
      @token.payload.decision = form_params[:_decision]

      @form_record = @virtual_model.load(@instance.payload)
      @form_record.assign_attributes(form_params.except(:_comment, :_action, :_decision))
      @transition_valid = @token.place.output_transition.options.valid?

      if @form_record.valid? && @transition_valid
        @instance.update! payload: (@instance.payload || {}).merge(@form_record.serializable_hash.except("_comment", "_action", "_decision"))
        @token.save!
        @token.place.output_transition.fire(@token, current_user: current_user)

        # redirect_to project_workflow_instance_tokens_url(@project, @workflow, @instance), notice: "Token was successfully fired."
        redirect_to project_workflows_url(@project), notice: "审批已成功执行！"
      else
        @tokens = @instance.tokens.where(hidden: false, status: %w[processing completed]).includes(:forwardable, :assignable, :processable, :place).order(id: :asc)
        render :show
      end
    end

    def forward
      member_id = params.require(:token)[:forwardable_id]
      member = @project.members.find(member_id)

      if member == current_member
        redirect_to project_workflows_url(@project)
        return
      end

      @new_token = @token.dup
      @new_token.assign_attributes assignable: member, forwardable: @token.assignable
      @new_token.save!

      @token.update! status: :terminated, hidden: true, processable: current_member
      redirect_to project_workflows_url(@project), notice: "审批已被转发成功！"
    end

    def endorse
      member_id = params.require(:token)[:endorsing_member_id]
      member = @project.members.find(member_id)

      if member == current_member
        redirect_to project_workflows_url(@project)
        return
      end

      if @token.place.tokens.where(instance: @instance, assignable_id: member).exists?
        redirect_to project_workflows_url(@project), notice: "该成员已在列表中"
        return
      end

      @new_token = @token.dup
      @new_token.assign_attributes assignable: member
      @new_token.save!

      redirect_to project_workflows_url(@project), notice: "已通过审批！"
    end

    def adding_observation
      field_overrides = @token.place.input_transition.options.try(:field_overrides)

      member_ids = params.require(:token)[:inviting_member_ids]
      members = @project.members.where(id: member_ids)
      members.each do |member|
        if member == current_member
          next
        end
        if member.user_id.blank?
          next
        end

        observation = @instance.observations.find_or_create_by(project: @project, workflow: @workflow, observable: member)
        observation.granted_by ||= current_member
        if field_overrides
          field_overrides.each do |fo|
            efo = observation.options.field_overrides.find { |fo1| fo1.name == fo.name }
            if efo
              if efo.accessibility == :hidden
                efo.accessibility = fo.accessibility
              end
            else
              observation.options.field_overrides << fo
            end
          end
        end
        observation.save
      end

      redirect_to project_workflow_instance_token_url(@project, @workflow, @instance, @token), notice: "已成功邀请！"
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_token
        @token = @instance.tokens.find(params[:id] || params[:token_id])
      end

      def require_relevant_person!
        unless @token.readable?(current_member)
          redirect_to project_workflow_instance_tokens_url(@project, @workflow, @instance)
        end
      end

      def set_form_model
        @form = @workflow.form
        overrides =
          if @token.processing?
            @token.place.output_transition.options.field_overrides.map { |o| { o.name => { accessibility: o.accessibility } } }.reduce(&:merge) || {}
          else
            { _global: { accessibility: :readonly } }.merge(@token.place.output_transition.options.field_overrides.map { |o| { o.name => { accessibility: o.accessibility == :read_and_write ? :readonly : o.accessibility } } }.reduce(&:merge) || {})
          end
        @virtual_model = @form.to_virtual_model overrides: overrides

        @virtual_model.attribute :_comment, :string
        @virtual_model.attribute :_action, :string
        @virtual_model.attribute :_decision, :string

        unless @token.processing?
          @virtual_model.attr_readonly :_comment, :_action, :_decision
        end
      end

      def form_record_params
        params.fetch(:form_record, {}).permit!
      end
  end
end
