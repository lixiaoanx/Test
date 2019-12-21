# frozen_string_literal: true

module Tenants::Admin
  class DictionariesController < Tenants::Admin::ApplicationController
    before_action :set_dictionary, only: %i[edit update destroy]

    # GET /dictionaries/dictionaries
    def index
      @dictionaries = @tenant.dictionaries.all
    end

    # GET /dictionaries/dictionaries/new
    def new
      @dictionary = @tenant.dictionaries.new
    end

    # GET /dictionaries/dictionaries/1/edit
    def edit; end

    # POST /dictionaries/dictionaries
    def create
      @dictionary = @tenant.dictionaries.new(dictionary_params)

      if @dictionary.save
        redirect_to tenant_admin_dictionaries_url(@tenant), notice: t("tenants.admin.dictionaries.shared.notice.created")
      else
        render :new
      end
    end

    # PATCH/PUT /dictionaries/dictionaries/1
    def update
      if @dictionary.update(dictionary_params)
        redirect_to tenant_admin_dictionaries_url(@tenant), notice: t("tenants.admin.dictionaries.shared.notice.updated")
      else
        render :edit
      end
    end

    # DELETE /dictionaries/dictionaries/1
    def destroy
      @dictionary.destroy
      redirect_to tenant_admin_dictionaries_url(@tenant), notice: t("tenants.admin.dictionaries.shared.notice.destroyed")
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_dictionary
        @dictionary = @tenant.dictionaries.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def dictionary_params
        params.fetch(:dictionary, {}).permit(:scope, :value)
      end
  end
end
