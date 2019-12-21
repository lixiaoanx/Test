# frozen_string_literal: true

module Tenants::Admin::Projects::Forms::Fields
  class OptionsController < Tenants::Admin::Projects::Forms::Fields::ApplicationController
    before_action :set_options

    def edit; end

    def update
      @options.assign_attributes(options_params)
      if @options.valid? && @field.save(validate: false)
        redirect_to edit_tenant_admin_project_form_field_options_url(@tenant, @project, @form, @field), notice: t("tenants.admin.projects.forms.fields.options.shared.notice.updated")
      else
        render :edit
      end
    end

    private

      def set_options
        @options = @field.options
      end

      def options_params
        params.fetch(:options, {}).permit!
      end
  end
end
