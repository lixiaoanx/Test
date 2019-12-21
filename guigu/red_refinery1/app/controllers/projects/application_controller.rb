# frozen_string_literal: true

module Projects
  class ApplicationController < ApplicationController
    before_action :authenticate_user!
    before_action :set_project
    before_action :require_membership!
    before_action :set_project_layout_data

    def current_member
      @_current_member ||= current_user.members.find_by(tenant: @project.tenant)
    end
    helper_method :current_member

    protected

      def require_membership!
        unless current_member&.accessible? && @project.members.where(id: current_member.id).exists?
          forbidden!
        end
      end

      def set_project
        @project = Project.find(params[:project_id])
      end

      def set_project_layout_data
        # @_sidebar_name = "project"
        @_breadcrumbs =
        [
          { text: I18n.t("layouts.header.nav.projects"), link: projects_path },
          { text: @project.name, link: project_path(@project) }
        ]
      end
  end
end
