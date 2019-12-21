# frozen_string_literal: true

module Tenants::Admin::Projects::Forms
  class PreviewsController < Tenants::Admin::Projects::Forms::ApplicationController
    before_action :set_preview

    def show
      @instance = @preview.new
    end

    def create
      @instance = @preview.new(preview_params)
      if @instance.valid?
        render :create
      else
        render :show
      end
    end

    private

      def set_preview
        @preview = @form.to_virtual_model
      end

      def preview_params
        params.fetch(:preview, {}).permit!
      end
  end
end
