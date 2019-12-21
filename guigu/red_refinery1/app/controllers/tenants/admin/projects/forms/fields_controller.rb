# frozen_string_literal: true

module Tenants::Admin::Projects::Forms
  class FieldsController < Tenants::Admin::Projects::Forms::ApplicationController
    before_action :set_field, only: %i[show edit update destroy]

    def index
      @fields = @form.fields.order(position: :asc)
    end

    def new
      @field = @form.fields.build
    end

    def edit; end

    def create
      @field = @form.fields.build(field_params)

      if @field.save
        redirect_to tenant_admin_project_form_fields_url(@tenant, @project, @form), notice: t("tenants.admin.projects.forms.fields.shared.notice.created")
      else
        render :new
      end
    end

    def update
      if @field.update(field_params)
        redirect_to tenant_admin_project_form_fields_url(@tenant, @project, @form), notice: t("tenants.admin.projects.forms.fields.shared.notice.updated")
      else
        render :edit
      end
    end

    def destroy
      @field.destroy
      redirect_to tenant_admin_project_form_fields_url(@tenant, @project, @form), notice: t("tenants.admin.projects.forms.fields.shared.notice.destroyed")
    end

    def move
      @field = @form.fields.find(params[:field_id])
      if @field && params[:position].present?
        index = params[:position].to_i
        @field.insert_at(index)
      end

      head :no_content
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_field
        @field = @form.fields.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def field_params
        params.fetch(:field, {}).permit(:name, :label, :hint, :accessibility, :type)
      end
  end
end
