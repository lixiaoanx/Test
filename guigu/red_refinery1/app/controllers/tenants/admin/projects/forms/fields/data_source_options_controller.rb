# frozen_string_literal: true

module Tenants::Admin::Projects::Forms::Fields
  class DataSourceOptionsController < Tenants::Admin::Projects::Forms::Fields::ApplicationController
    before_action :require_data_source_options
    before_action :set_options

    def edit; end

    def update
      @options.assign_attributes(options_params)
      if @options.valid? && @field.save(validate: false)
        redirect_to edit_tenant_admin_project_form_field_data_source_options_url(@tenant, @project, @form, @field), notice: t("tenants.admin.projects.forms.fields.data_source_options.shared.notice.updated")
      else
        render :edit
      end
    end

    private

      def require_data_source_options
        unless @field.respond_to?(:data_source)
          redirect_to edit_tenant_admin_project_form_fields_url(@tenant, @project, @form, @field)
        end
      end

      def set_options
        @options = @field.data_source
      end

      def options_params
        params.fetch(:options, {}).permit!
      end
  end
end
