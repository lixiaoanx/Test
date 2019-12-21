# frozen_string_literal: true

module Api
  class ApiError < StandardError
    def response_status
      raise NotImplementedError
    end

    def error_payload
      raise NotImplementedError
    end
  end

  class ResourceNotFound < ApiError
    attr_reader :param_key

    def initialize(param_key)
      @param_key = param_key
    end

    def response_status
      :not_found
    end

    def error_payload
      {
        type: "ResourceNotFound",
        data: param_key
      }
    end
  end

  class EntityInvalid < ApiError
    attr_reader :errors

    def initialize(errors)
      @errors = errors
    end

    def response_status
      :unprocessable_entity
    end

    def error_payload
      {
        type: "EntityInvalid",
        data: errors&.details
      }
    end
  end

  class OperationFailure < ApiError
    attr_reader :errors, :status

    def initialize(errors, status: :unprocessable_entity)
      @errors = errors
      @status = status
    end

    def response_status
      status
    end

    def error_payload
      {
        type: "OperationFailure",
        data: errors
      }
    end
  end

  class SignatureInvalid < ApiError
    def response_status
      :bad_request
    end

    def error_payload
      nil
    end
  end
end
