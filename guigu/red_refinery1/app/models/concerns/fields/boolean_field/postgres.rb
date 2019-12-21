# frozen_string_literal: true

module Fields
  module BooleanField::Postgres
    extend ActiveSupport::Concern

    def pg_type
      "boolean"
    end
  end
end
