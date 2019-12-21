# frozen_string_literal: true

module Fields
  module BooleanField::CustomQuery
    extend ActiveSupport::Concern

    def filter_class
      ::FieldFilterConditions::Boolean
    end
  end
end
