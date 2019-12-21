# frozen_string_literal: true

module Fields
  module DateField::CustomQuery
    extend ActiveSupport::Concern

    def filter_class
      ::FieldFilterConditions::Date
    end

    def can_group_by?
      true
    end

    def supported_aggregations
      %w[max min]
    end
  end
end
