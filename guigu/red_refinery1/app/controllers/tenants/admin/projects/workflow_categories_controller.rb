# frozen_string_literal: true

module Tenants::Admin::Projects
  class WorkflowCategoriesController < Tenants::Admin::Projects::ApplicationController
    before_action :set_workflow_category, only: %i[edit update destroy]

    # GET /workflow_categories/workflow_categories
    def index
      @workflow_categories = @project.workflow_categories.all
    end

    # GET /workflow_categories/workflow_categories/new
    def new
      @workflow_category = @project.workflow_categories.new
    end

    # GET /workflow_categories/workflow_categories/1/edit
    def edit; end

    # POST /workflow_categories/workflow_categories
    def create
      @workflow_category = @project.workflow_categories.new(workflow_category_params)
      @workflow_category.tenant = @tenant

      if @workflow_category.save
        redirect_to tenant_admin_project_workflow_categories_url(@tenant, @project), notice: t("tenants.admin.projects.workflow_categories.shared.notice.created")
      else
        render :new
      end
    end

    # PATCH/PUT /workflow_categories/workflow_categories/1
    def update
      if @workflow_category.update(workflow_category_params)
        redirect_to tenant_admin_project_workflow_categories_url(@tenant, @project), notice: t("tenants.admin.projects.workflow_categories.shared.notice.updated")
      else
        render :edit
      end
    end

    # DELETE /workflow_categories/workflow_categories/1
    def destroy
      @workflow_category.destroy
      redirect_to tenant_admin_workflow_categories_url(@tenant), notice: t("tenants.admin.projects.workflow_categories.shared.notice.destroyed")
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_workflow_category
        @workflow_category = @project.workflow_categories.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def workflow_category_params
        params.fetch(:workflow_category, {}).permit(:title)
      end
  end
end
