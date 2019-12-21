# frozen_string_literal: true

module Fields
  module ChoiceField::CustomQuery
    extend ActiveSupport::Concern

    def filter_class
      ::FieldFilterConditions::Choice
    end

    def can_group_by?
      true
    end
  end
end
