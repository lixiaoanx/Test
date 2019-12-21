# frozen_string_literal: true

module Projects::Workflows
  class ApplicationController < Projects::ApplicationController
    before_action :set_workflow
    before_action :set_workflow_layout_data, if: -> { request.format.html? }

    protected

      def set_workflow
        @workflow = @project.workflows.find(params[:workflow_id])
      end

      def set_workflow_layout_data
        @_breadcrumbs.concat(
          [
            { text: @workflow.title, link: project_workflow_path(@project, @workflow) }
          ]
        )
      end
  end
end
