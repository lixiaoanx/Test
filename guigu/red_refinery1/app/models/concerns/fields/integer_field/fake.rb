# frozen_string_literal: true

module Fields
  module IntegerField::Fake
    extend ActiveSupport::Concern

    def generate_fake_value_to(record)
      record.write_attribute(name, Faker::Number.between(from: -65535, to: 65535))
    end
  end
end
