# frozen_string_literal: true

module Fields
  module MultipleAttachmentField::Fake
    extend ActiveSupport::Concern

    def generate_fake_value_to(record)
      raise NotImplementedError
    end
  end
end
