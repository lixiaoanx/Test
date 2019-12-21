# frozen_string_literal: true

module Tenants::Admin::Projects::Workflows
  class TransitionsController < Tenants::Admin::Projects::Workflows::ApplicationController
    before_action :set_transition, only: %i[edit update destroy]

    def index
      @transitions = @workflow.transitions.order(id: :asc)
    end

    def edit; end

    def update
      if @transition.update!(transition_params)
        redirect_to tenant_admin_project_workflow_transitions_url(@tenant, @project, @workflow), notice: "transition was successfully updated."
      else
        render :edit
      end
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_transition
        @transition = @workflow.transitions.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def transition_params
        params.fetch(:transition, {}).permit(:title, :type)
      end
  end
end
