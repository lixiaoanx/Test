# frozen_string_literal: true

module Fields
  module ResourceSelectField::CustomQuery
    extend ActiveSupport::Concern

    def filter_class
      ::FieldFilterConditions::Text
    end

    def can_group_by?
      true
    end
  end
end
