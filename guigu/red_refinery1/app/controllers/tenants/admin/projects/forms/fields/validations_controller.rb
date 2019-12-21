# frozen_string_literal: true

module Tenants::Admin::Projects::Forms::Fields
  class ValidationsController < Tenants::Admin::Projects::Forms::Fields::ApplicationController
    before_action :set_validations

    def edit; end

    def update
      @validations.assign_attributes(validations_params)
      if @validations.valid? && @field.save(validate: false)
        redirect_to edit_tenant_admin_project_form_field_validations_url(@tenant, @project, @form, @field), notice: t("tenants.admin.projects.forms.fields.validations.shared.notice.updated")
      else
        render :edit
      end
    end

    private

      def set_validations
        @validations = @field.validations
      end

      def validations_params
        params.fetch(:validations, {}).permit!
      end
  end
end
