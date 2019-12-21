# frozen_string_literal: true

module Tenants::Admin::Projects::Forms::Fields
  class ChoicesController < Tenants::Admin::Projects::Forms::Fields::ApplicationController
    before_action :require_attach_choices!
    before_action :set_choice, only: %i[edit update destroy]

    def index
      @choices = @field.choices
    end

    def new
      @choice = @field.choices.build
    end

    def create
      @choice = @field.choices.build choice_params
      if @choice.save
        redirect_to tenant_admin_project_form_field_choices_url(@tenant, @project, @form, @field), notice: t("tenants.admin.projects.forms.fields.choices.shared.notice.created")
      else
        render :new
      end
    end

    def edit; end

    def update
      if @choice.update choice_params
        redirect_to tenant_admin_project_form_field_choices_url(@tenant, @project, @form, @field), notice: t("tenants.admin.projects.forms.fields.choices.shared.notice.updated")
      else
        render :edit
      end
    end

    def destroy
      @choice.destroy
      redirect_to tenant_admin_project_form_field_choices_url(@tenant, @project, @form, @field), notice: t("tenants.admin.projects.forms.fields.choices.shared.notice.destroyed")
    end

    private

      def require_attach_choices!
        unless @field.attached_choices?
          redirect_to edit_tenant_admin_project_form_field_url(@tenant, @project, @form, @field)
        end
      end

      def choice_params
        params.require(:choice).permit(:label)
      end

      def set_choice
        @choice = @field.choices.find(params[:id])
      end
  end
end
