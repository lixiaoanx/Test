# frozen_string_literal: true

module Fields
  module DecimalField::CustomQuery
    extend ActiveSupport::Concern

    def filter_class
      ::FieldFilterConditions::Decimal
    end

    def supported_aggregations
      %w[sum avg max min]
    end
  end
end
