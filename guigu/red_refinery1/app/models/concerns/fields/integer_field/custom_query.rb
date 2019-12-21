# frozen_string_literal: true

module Fields
  module IntegerField::CustomQuery
    extend ActiveSupport::Concern

    def filter_class
      ::FieldFilterConditions::Integer
    end

    def can_group_by?
      false
    end

    def supported_aggregations
      %w[sum avg max min]
    end
  end
end
