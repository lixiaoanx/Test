# frozen_string_literal: true

module Fields
  module MultipleResourceSelectField::Fake
    extend ActiveSupport::Concern

    def generate_fake_value_to(_record)
      raise NotImplementedError
    end
  end
end
