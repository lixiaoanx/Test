# frozen_string_literal: true

module Tenants::Admin::Projects
  class FormsController < Tenants::Admin::Projects::ApplicationController
    before_action :set_form, only: [:show, :edit, :update, :destroy]
    before_action :set_form_layout_data, only: [:show, :edit, :update], if: -> { request.format.html? }

    def index
      prepare_meta_tags title: t(".title")

      @forms = @project.forms.all.page(params[:page]).per(params[:per_page])
    end

    def show
      redirect_to tenant_admin_project_form_fields_url(@tenant, @project, @form)
    end

    def new
      prepare_meta_tags title: t(".title")

      @form = @project.forms.new
    end

    def edit
    end

    def create
      @form = @project.forms.new(form_params_for_create)

      respond_to do |format|
        if @form.save
          format.html { redirect_to tenant_admin_project_form_url(@tenant, @project, @form), notice: t("tenants.admin.projects.forms.shared.notice.created") }
        else
          format.html do
            prepare_meta_tags title: t("tenants.admin.projects.forms.new.title")
            render :new
          end
        end
      end
    end

    def update
      respond_to do |format|
        if @form.update(form_params)
          format.html { redirect_to tenant_admin_project_form_url(@tenant, @project, @form), notice: t("tenants.admin.projects.forms.shared.notice.updated") }
        else
          format.html do
            render :edit
          end
        end
      end
    end

    def destroy
      @form.destroy

      respond_to do |format|
        format.html { redirect_to tenant_admin_project_forms_url(@tenant, @project), notice: t("tenants.admin.projects.forms.shared.notice.destroyed") }
      end
    end

    def random
      @form = Form.create_random_form! tenant: @tenant, project: @project

      redirect_to tenant_admin_project_form_url(@tenant, @project, @form), notice: "Form was successfully generated."
    end

    private

      def set_form
        @form = @project.forms.find(params[:id])
      end

      def form_params_for_create
        params.fetch(:form, {}).permit(:name, :title, :description)
      end

      def form_params
        params.fetch(:form, {}).permit(:title, :description)
      end

      def set_form_layout_data
        prepare_meta_tags title: @form.title

        @_breadcrumbs =
          [
            { text: t("tenants.admin.projects.shared.title"), link: tenant_admin_projects_path(@tenant) },
            { text: @project.name, link: tenant_admin_project_path(@tenant, @project) },
            { text: t("tenants.admin.projects.forms.shared.title"), link: tenant_admin_project_forms_path(@tenant, @project) },
            { text: @form.title, link: tenant_admin_project_form_path(@tenant, @project, @form) }
          ]
      end
  end
end
