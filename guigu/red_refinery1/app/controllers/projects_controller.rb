# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show]
  before_action :require_membership!, only: %i[show]
  before_action :set_project_layout_data, only: %i[show]

  def index
    @members = current_user.members
    @tenants = current_user.tenants
    @projects = current_user.projects
  end

  def show
    @my_instances = @project.workflow_instances.processing.where(creator: [current_member, *current_member.groups]).includes(:tenant, :project)
    @pending_tokens = @project.tokens.processing.where(assignable: [current_member, *current_member.groups]).includes(:tenant, :project, instance: [:workflow])
    if params[:category_id].present?
      @pending_tokens = @pending_tokens.joins(:workflow).where(workflows: { category_id: params[:category_id] })
    end
    @pending_observations = @project.workflow_instance_observations.where(read: false).where(observable: [current_member, *current_member.groups]).includes(instance: [:workflow])
  end

  private

    def current_member
      @_current_member ||= current_user.members.find_by(tenant: @project.tenant)
    end
    helper_method :current_member

    def require_membership!
      unless current_member&.accessible? && @project.members.where(id: current_member.id).exists?
        forbidden!
      end
    end

    def set_project
      @project = current_user.projects.find(params[:id])
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
