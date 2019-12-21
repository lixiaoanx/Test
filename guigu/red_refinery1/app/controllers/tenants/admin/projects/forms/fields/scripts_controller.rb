# frozen_string_literal: true

module Tenants::Admin::Projects::Forms::Fields
  class ScriptsController < Tenants::Admin::Projects::Forms::Fields::ApplicationController
    def edit; end

    def update
      if @field.update(field_params)
        redirect_to edit_tenant_admin_project_form_field_scripts_url(@tenant, @project, @form, @field), notice: t("tenants.admin.projects.forms.fields.scripts.shared.notice.updated")
      else
        render :edit
      end
    end

    private

      def field_params
        params.fetch(:field, {}).permit(:script)
      end
  end
end
