# frozen_string_literal: true

module Fields
  module MultipleSelectField::CustomQuery
    extend ActiveSupport::Concern

    def can_group_by?
      true
    end
  end
end
