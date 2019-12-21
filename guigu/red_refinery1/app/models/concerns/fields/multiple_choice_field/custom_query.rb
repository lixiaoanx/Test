# frozen_string_literal: true

module Fields
  module MultipleChoiceField::CustomQuery
    extend ActiveSupport::Concern

    def filter_class
      ::FieldFilterConditions::MultipleChoice
    end

    def can_group_by?
      true
    end

    def supported_aggregations
      %w[count]
    end
  end
end
