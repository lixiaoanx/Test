# frozen_string_literal: true

module Tenants::Admin::Projects
  class ApplicationController < Tenants::Admin::ApplicationController
    before_action :set_project
    before_action :set_project_layout_data

    protected

      def set_project
        @project = @tenant.projects.find(params[:project_id])
      end

      def set_project_layout_data
        @_sidebar_name = "tenant_admin_project"
        @_breadcrumbs =
          [
            # { text: t("tenants.admin.projects.index.title"), link: tenant_admin_projects_path(@tenant) },
            { text: @project.name, link: project_path(@project) }
          ]
      end
  end
end
