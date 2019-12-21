# frozen_string_literal: true

module Fields
  module ResourceField::CustomQuery
    extend ActiveSupport::Concern

    def filter_class
      ::FieldFilterConditions::Resource
    end

    def can_group_by?
      true
    end
  end
end
