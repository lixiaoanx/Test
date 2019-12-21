# frozen_string_literal: true

module Fields
  module DateField::Postgres
    extend ActiveSupport::Concern

    def pg_type
      "date"
    end
  end
end
