# frozen_string_literal: true

module Tenants::Admin::Projects::Workflows
  class InstancesController < Tenants::Admin::Projects::Workflows::ApplicationController
    before_action :set_instance, only: %i[show]

    def index
      @instances = @workflow.instances.order(id: :desc)
    end

    def show
      @tokens = @instance.tokens.where(hidden: false, status: %w[processing completed]).includes(:forwardable, :assignable, :processable, :place).order(id: :asc)

      @form = @workflow.form
      @virtual_model = @form.to_virtual_model
      @form_record = @virtual_model.new(@instance.payload)
    end

    def destroy
      @instance = @workflow.instances.find(params[:id])
      unless @instance.processing?
        redirect_to tenant_admin_project_workflow_instances_url(@tenant, @project, @workflow)
        return
      end

      @instance.terminate!(closed_by: current_member)

      redirect_to tenant_admin_project_workflow_instances_url(@tenant, @project, @workflow), notice: "审批已被关闭"
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_instance
        @instance = @workflow.instances.find(params[:id])
      end
  end
end
