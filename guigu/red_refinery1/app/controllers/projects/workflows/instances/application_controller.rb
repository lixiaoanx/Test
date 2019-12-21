# frozen_string_literal: true

module Projects::Workflows::Instances
  class ApplicationController < Projects::Workflows::ApplicationController
    before_action :set_instance
    before_action :set_instance_layout_data, if: -> { request.format.html? }

    protected

      def require_creator_or_observer!
        return if @instance.creator == current_member
        @observation = @instance.observations.where(observable: [current_member, *current_member.groups]).first
        return if @observation

        redirect_to project_workflows_url(@project)
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_instance
        @instance = @workflow.instances.find(params[:instance_id])
      end

      def set_instance_layout_data
        @_breadcrumbs << { text: "##{@instance.id}", link: project_workflow_instance_path(@project, @workflow, @instance) }
      end
  end
end
