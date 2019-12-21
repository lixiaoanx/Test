# frozen_string_literal: true

module Tenants::Admin::Projects::Workflows
  class ApplicationController < Tenants::Admin::Projects::ApplicationController
    before_action :set_workflow
    before_action :set_workflow_layout_data, if: -> { request.format.html? }

    protected

      def set_workflow
        @workflow = @project.workflows.find(params[:workflow_id])
      end

      def set_workflow_layout_data
        @_breadcrumbs =
          [
            { text: t("tenants.admin.projects.shared.title"), link: tenant_admin_projects_path(@tenant) },
            { text: @project.name, link: tenant_admin_project_path(@tenant, @project) },
            { text: t("tenants.admin.projects.workflows.shared.title"), link: tenant_admin_project_workflows_path(@tenant, @project) },
            { text: @workflow.title, link: tenant_admin_project_workflow_path(@tenant, @project, @workflow) }
          ]
      end
  end
end
