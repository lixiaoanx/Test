# frozen_string_literal: true

module Projects
  class WorkflowsController < Projects::ApplicationController
    before_action :set_workflow, only: [:show]
    before_action :set_workflow_layout_data, only: [:show]

    def index
      prepare_meta_tags title: t(".title")


      params[:filter] ||= "all"
      @all_instances = @project.workflow_instances.includes(:workflow).where(creator: current_member)
      @workflows = @project.workflows.includes(:category).active.for(current_member)
      @processing_instances = @project.workflow_instances.processing.includes(:workflow).where(creator: current_member)
      @terminated_instances = @project.workflow_instances.terminated.includes(:workflow).where(creator: current_member)

      @instances = case params[:filter]
                   when "all" then @all_instances
                   when "processing" then @processing_instances
                   when "terminated" then @terminated_instances
                   else @all_instances
      end

      if params[:category_id].present?
        @instances = @instances.where(workflows: { category_id: params[:category_id] })
      end
      @need_me_review_instances = @project.workflow_instances.includes(:workflow).joins(:observations).where(workflow_instance_observations: { observable_type: "Member", observable_id: current_member.id })
      @all_viewable_instances = @project.workflow_instances.joins(" INNER JOIN (#{@project.workflows.visible_for(current_member).to_sql}) as w on w.id = workflow_instances.workflow_id").includes(:workflow)

      # 分页
      @instances = @instances.order(id: :desc).page(params[:page]).per(15)
      @all_viewable_instances = @all_viewable_instances.order(id: :desc).page(params[:all_ins_page]).per(15)
      @need_me_review_instances = @need_me_review_instances.order(id: :desc).page(params[:need_review_page]).per(15)

      @_breadcrumbs =
        [
          { text: I18n.t("layouts.header.nav.projects"), link: projects_path },
          { text: @project.name, link: project_path(@project) },
          { text: "全部审批", link: project_workflows_path(@project) }
        ]
    end

    def show
    end

    private

      def set_workflow
        @workflow = @project.workflows.find(params[:id])
      end

      def set_workflow_layout_data
        prepare_meta_tags title: @workflow.title

        @_breadcrumbs.concat [
          { text: t("projects.workflows.shared.title"), link: project_workflows_path(@project) },
          { text: @workflow.title, link: project_workflow_path(@project, @workflow) }
        ]
      end
  end
end
