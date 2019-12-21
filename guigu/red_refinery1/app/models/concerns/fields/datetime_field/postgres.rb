# frozen_string_literal: true

module Fields
  module DatetimeField::Postgres
    extend ActiveSupport::Concern

    def pg_type
      "timestamp"
    end
  end
end
