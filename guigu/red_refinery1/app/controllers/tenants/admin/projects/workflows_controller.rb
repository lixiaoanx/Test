# frozen_string_literal: true

module Tenants::Admin::Projects
  class WorkflowsController < Tenants::Admin::Projects::ApplicationController
    before_action :set_workflow, only: [:show, :edit, :update, :destroy]
    before_action :set_workflow_layout_data, only: [:show, :edit, :update], if: -> { request.format.html? }

    def index
      prepare_meta_tags title: t(".title")

      @workflows = @project.workflows.active.all.page(params[:page]).per(params[:per_page])
    end

    def show
    end

    def new
      prepare_meta_tags title: t(".title")

      @workflow = @project.workflows.new
    end

    def edit
    end

    def create
      @workflow = @project.workflows.new(workflow_params_for_create)

      respond_to do |format|
        if @workflow.save!
          format.html { redirect_to tenant_admin_project_workflow_url(@tenant, @project, @workflow), notice: t("tenants.admin.projects.workflows.shared.notice.created") }
        else
          format.html do
            prepare_meta_tags title: t("tenants.admin.projects.workflows.new.title")
            render :new
          end
        end
      end
    end

    def update
      respond_to do |format|
        if @workflow.update(workflow_params)
          format.html { redirect_to tenant_admin_project_workflow_url(@tenant, @project, @workflow), notice: t("tenants.admin.projects.workflows.shared.notice.updated") }
        else
          format.html do
            render :edit
          end
        end
      end
    end

    def destroy
      @workflow.destroy

      respond_to do |format|
        format.html { redirect_to tenant_admin_project_workflows_url(@tenant, @project), notice: t("tenants.admin.projects.workflows.shared.notice.destroyed") }
      end
    end

    private

      def set_workflow
        @workflow = @project.workflows.find(params[:id])
      end

      def workflow_params_for_create
        params.fetch(:workflow, {}).permit(:form_id, :title, :description, :category_id, :accessibility, :visibility, accessible_member_ids: [], accessible_group_ids: [], visible_member_ids: [], visible_group_ids: [])
      end

      def workflow_params
        params.fetch(:workflow, {}).permit(:title, :description, :category_id, :accessibility, :visibility, accessible_member_ids: [], accessible_group_ids: [], visible_member_ids: [], visible_group_ids: [])
      end

      def set_workflow_layout_data
        prepare_meta_tags title: @workflow.title

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
