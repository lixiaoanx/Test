# frozen_string_literal: true

module Tenants::Admin::Projects::Forms::Fields
  class ApplicationController < Tenants::Admin::Projects::Forms::ApplicationController
    before_action :set_field

    protected

      # Use callbacks to share common setup or constraints between actions.
      def set_field
        @field = @form.fields.find(params[:field_id])
      end
  end
end
