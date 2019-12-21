# frozen_string_literal: true

module Tenants::Admin::Projects::Workflows::Instances
  class ApplicationController < Tenants::Admin::Projects::Workflows::ApplicationController
    before_action :set_instance
    before_action :set_instance_layout_data, if: -> { request.format.html? }

    protected

      # Use callbacks to share common setup or constraints between actions.
      def set_instance
        @instance = @workflow.instances.find(params[:instance_id])
      end

      def set_instance_layout_data
        @_breadcrumbs << { text: "##{@instance.id}", link: project_workflow_instance_path(@project, @workflow, @instance) }
      end
  end
end
