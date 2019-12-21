# frozen_string_literal: true

module Tenants::Admin::Projects::Workflows
  class LoadsController < Tenants::Admin::Projects::Workflows::ApplicationController
    def show; end

    def update
      bpmn_xml = permitted_params[:bpmn_xml].presence || permitted_params[:bpmn_file]&.read
      old_workflow = @workflow
      @workflow = @workflow.clone_with_transition_and_place
      @workflow.load_from_bpmn!(bpmn_xml)
      @workflow.active!
      old_workflow.inactive!

      redirect_to tenant_admin_project_workflow_url(@tenant, @project, @workflow), notice: "Workflow definition was successfully imported."
    end

    private

      # Only allow a trusted parameter "white list" through.
      def permitted_params
        params.permit(:bpmn_xml, :bpmn_file)
      end
  end
end
