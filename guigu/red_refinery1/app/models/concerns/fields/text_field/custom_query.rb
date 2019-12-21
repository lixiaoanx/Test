# frozen_string_literal: true

module Fields
  module TextField::CustomQuery
    extend ActiveSupport::Concern

    def filter_class
      ::FieldFilterConditions::Text
    end
  end
end
