# frozen_string_literal: true

module Fields
  module DatetimeField::CustomQuery
    extend ActiveSupport::Concern

    def filter_class
      ::FieldFilterConditions::Datetime
    end

    def supported_aggregations
      %w[max min]
    end
  end
end
