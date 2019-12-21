# frozen_string_literal: true

module Projects::Workflows::Instances
  class ObservationsController < Projects::Workflows::Instances::ApplicationController
    before_action :require_creator_or_observer!

    def index
      @observations = @instance.observations.includes(:observable, :granted_by)
    end

    def update
      @observation.update observation_params.merge(read: true)

      redirect_to project_workflow_instance_path(@project, @workflow, @instance)
    end

    private

      def observation_params
        params.require(:observation).permit(:comment)
      end
  end
end
