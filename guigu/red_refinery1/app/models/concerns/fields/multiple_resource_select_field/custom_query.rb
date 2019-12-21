# frozen_string_literal: true

module Fields
  module MultipleResourceSelectField::CustomQuery
    extend ActiveSupport::Concern

    def can_group_by?
      true
    end
  end
end
