# frozen_string_literal: true

module Tenants::Admin::Projects::Workflows::Transitions
  class OptionsController < Tenants::Admin::Projects::Workflows::Transitions::ApplicationController
    before_action :set_options

    def edit; end

    def update
      @options.assign_attributes(options_params)
      if @options.valid? && @transition.save(validate: false)
        redirect_to tenant_admin_project_workflow_transitions_url(@tenant, @project, @workflow), notice: "Transition was successfully updated."
      else
        render :edit
      end
    end

    private

      def set_options
        @options = @transition.options
      end

      def options_params
        params.fetch(:options, {}).permit!
      end
  end
end
