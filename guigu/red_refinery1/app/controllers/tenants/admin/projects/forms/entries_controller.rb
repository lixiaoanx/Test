# frozen_string_literal: true

module Tenants::Admin::Projects::Forms
  class EntriesController < Tenants::Admin::Projects::Forms::ApplicationController
    before_action :set_virtual_model, only: %i[new create edit update]
    before_action :set_readonly_virtual_model, only: %i[show]

    before_action :set_entry, only: %i[show edit update destroy]

    # GET /forms/1/entries
    def index
      @records = @form.pg_ar_class.page(params[:page]).per(params[:per_page])
    end

    # GET /forms/entries/new
    def new
      @record = @virtual_model.new
    end

    # GET /forms/1/entries/1
    def show
      @record = @form.load_entry(@entry, virtual_model: @virtual_model)
    end

    # GET /forms/1/entries/1/edit
    def edit
      @record = @form.load_entry(@entry, virtual_model: @virtual_model)
    end

    # POST /forms/1/entries
    def create
      @record = @virtual_model.new(record_params)
      if @record.valid?
        entry = @form.save_virtual_record!(@record)
        redirect_to tenant_admin_project_form_entry_url(@tenant, @project, @form, entry), notice: "Entry was successfully created."
      else
        render :new
      end
    end

    # PATCH/PUT /forms/1/entries/1
    def update
      @record = @virtual_model.new(record_params)
      if @record.valid?
        @form.save_virtual_record!(@record, @entry)
        redirect_to tenant_admin_project_form_entry_url(@tenant, @project, @form, @entry), notice: "Entry was successfully updated."
      else
        render :edit
      end
    end

    # DELETE /forms/1/entries/1
    def destroy
      @entry.destroy
      redirect_to tenant_admin_project_form_entries_url(@tenant, @project, @form), notice: "Entry was successfully destroyed."
    end

    def random
      @form.create_random_record!

      redirect_to tenant_admin_project_form_entries_url(@tenant, @project, @form), notice: "Entry was successfully generated."
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_entry
        @entry = @form.entries.find(params[:id])
      end

      def set_readonly_virtual_model
        @virtual_model = @form.to_virtual_model(overrides: { _global: { accessibility: :readonly } })
      end

      def set_virtual_model
        @virtual_model = @form.to_virtual_model
      end

      def record_params
        params.fetch(:record, {}).permit!
      end
  end
end
