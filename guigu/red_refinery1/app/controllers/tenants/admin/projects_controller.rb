# frozen_string_literal: true

module Tenants::Admin
  class ProjectsController < Tenants::Admin::ApplicationController
    before_action :set_project, only: [:show, :edit, :update, :destroy]

    def index
      @projects = @tenant.projects.page(params[:page]).per(params[:per_page])
    end

    def show
      @_sidebar_name = "tenant_admin_project"
      @_breadcrumbs =
        [
          # { text: t("tenants.admin.projects.index.title"), link: tenant_admin_projects_path(@tenant) },
          { text: @project.name, link: tenant_admin_project_path(@tenant, @project) }
        ]
    end

    def new
      @project = @tenant.projects.new
    end

    def edit
      @_sidebar_name = "tenant_admin_project"
      @_breadcrumbs =
        [
          # { text: t("tenants.admin.projects.index.title"), link: tenant_admin_projects_path(@tenant) },
          { text: @project.name, link: tenant_admin_project_path(@tenant, @project) }
        ]
    end

    def create
      @project = @tenant.projects.new(project_params)

      if @project.save
        redirect_to tenant_admin_project_url(@tenant, @project), notice: t(".shared.notice.created")
      else
        render :new
      end
    end

    def update
      if @project.update(project_params)
        redirect_to tenant_admin_project_url(@tenant, @project), notice: t(".shared.notice.updated")
      else
        @_sidebar_name = "tenant_admin_project"
        @_breadcrumbs =
          [
            # { text: t("tenants.admin.projects.index.title"), link: tenant_admin_projects_path(@tenant) },
            { text: @project.name, link: project_path(@project) }
          ]
        render :edit
      end
    end

    def destroy
      @project.destroy

      redirect_to tenant_admin_projects_url(@tenant), notice: t(".shared.notice.deleted")
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_project
        @project = @tenant.projects.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def project_params
        params.require(:project).permit(:name, :redmine_project_id)
      end
  end
end
