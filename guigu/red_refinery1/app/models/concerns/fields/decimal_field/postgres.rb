# frozen_string_literal: true

module Fields
  module DecimalField::Postgres
    extend ActiveSupport::Concern

    def pg_type
      "decimal"
    end
  end
end
