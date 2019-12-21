# frozen_string_literal: true

module Tenants::Admin::Projects::Forms
  class ApplicationController < Tenants::Admin::Projects::ApplicationController
    before_action :set_form
    before_action :set_form_layout_data, if: -> { request.format.html? }

    protected

      def set_form
        @form = @project.metal_forms.find(params[:form_id])
      end

      def set_form_layout_data
        @_breadcrumbs =
          [
            { text: t("tenants.admin.projects.shared.title"), link: tenant_admin_projects_path(@tenant) },
            { text: @project.name, link: tenant_admin_project_path(@tenant, @project) },
            { text: t("tenants.admin.projects.forms.shared.title"), link: tenant_admin_project_forms_path(@tenant, @project) },
          ]

        if @form.attachable_id.present? && @form.attachable.is_a?(Field)
          @_breadcrumbs << { text: @form.attachable.form.title, link: tenant_admin_project_form_path(@tenant, @project, @form.attachable.form) }
          @_breadcrumbs << { text: @form.attachable.label, link: edit_tenant_admin_project_form_field_path(@tenant, @project, @form.attachable.form, @form.attachable) }
          @_breadcrumbs << { text: t("tenants.admin.projects.forms.shared.title"), link: tenant_admin_project_form_fields_path(@tenant, @project, @form) }
        else
          @_breadcrumbs << { text: @form.title, link: tenant_admin_project_form_path(@tenant, @project, @form) }
        end
      end
  end
end
