# frozen_string_literal: true

module Api
  class ApiController < ActionController::API
    Api::ApiError.descendants.each do |klass|
      rescue_from klass do |ex|
        render status: ex.response_status,
               json: {
                 status: "error",
                 error: ex.error_payload
               }
      end
    end

    def render_ok(data = nil)
      render json: {
        status: "ok",
        data: data
      }
    end
    helper_method :render_ok
  end
end
