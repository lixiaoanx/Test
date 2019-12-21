# frozen_string_literal: true

module Fields
  module IntegerField::Postgres
    extend ActiveSupport::Concern

    def pg_type
      "bigint"
    end
  end
end
