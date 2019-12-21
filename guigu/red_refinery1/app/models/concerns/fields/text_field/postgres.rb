# frozen_string_literal: true

module Fields
  module TextField::Postgres
    extend ActiveSupport::Concern

    def pg_type
      "varchar"
    end
  end
end
