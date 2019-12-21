# frozen_string_literal: true

module Projects::Workflows
  class InstancesController < Projects::Workflows::ApplicationController
    before_action :require_accessible!, only: %i[new create]
    before_action :set_instance, only: %i[show]
    before_action :require_creator_or_observer!, only: %i[show]

    def show
      @form = @workflow.form
      overrides =
        if @observation
          @observation.options.field_overrides.map { |o| { o.name => { accessibility: o.accessibility } } }.reduce(&:merge) || {}

        else
          {}
        end
      @virtual_model = @form.to_virtual_model overrides: overrides
      @form_record = @virtual_model.new(@instance.payload)
      @observations = @instance.observations.includes(:observable, :granted_by)
      @tokens = @instance.tokens.where(hidden: false, status: %w[processing completed]).includes(:forwardable, :assignable, :processable, :place).order(id: :asc)

      @_breadcrumbs << { text: "##{@instance.id}", link: project_workflow_instance_path(@project, @workflow, @instance) }
    end

    def new
      @form = @workflow.form
      overrides = @workflow.start_place.output_transition.options.field_overrides.map { |o| { o.name => { accessibility: o.accessibility } } }.reduce(&:merge) || {}
      @virtual_model = @form.to_virtual_model overrides: overrides

      @form_record = @virtual_model.new
    end

    def create
      @form = @workflow.form
      overrides = @workflow.start_place.output_transition.options.field_overrides.map { |o| { o.name => { accessibility: o.accessibility } } }.reduce(&:merge) || {}
      @virtual_model = @form.to_virtual_model overrides: overrides

      @form_record = @virtual_model.new form_record_params
      unless @form_record.valid?
        render :new
        return
      end

      @instance = @workflow.instances.create! type: "WorkflowInstance", project: @project, tenant: @project.tenant, creator: current_member
      @instance.update! payload: @form_record.serializable_hash
      start_token = @instance.tokens.first
      start_token.place.output_transition.fire(start_token, current_user: current_user)

      # redirect_to project_workflow_instances_url(@project, @workflow), notice: "instance was successfully created."
      redirect_to project_workflows_url(@project), success: "审批已成功发起！"
    end

    def destroy
      @instance = @workflow.instances.find(params[:id])
      unless @instance.processing? && @instance.creator == current_member
        redirect_to project_workflows_url(@project)
        return
      end

      @instance.terminate!(closed_by: current_member)

      redirect_to project_workflows_url(@project), notice: "审批已被关闭"
    end

    private

      def form_record_params
        params.fetch(:form_record, {}).permit!
      end

      def require_accessible!
        return if @workflow.access_public?
        if @workflow.access_whitelist?
          return if @workflow.accessibilities.where(target: [current_member, *current_member.groups]).exists?
        end

        redirect_to project_workflows_url(@project)
      end

      def set_instance
        @instance = @workflow.instances.find(params[:id])
      end

      def require_creator_or_observer!
        @observation = @instance.observations.where(observable: [current_member, *current_member.groups]).first
        return if @observation
        return if @instance.creator == current_member

        redirect_to project_workflows_url(@project)
      end
  end
end
