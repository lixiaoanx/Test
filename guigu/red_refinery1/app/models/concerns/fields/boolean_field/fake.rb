# frozen_string_literal: true

module Fields
  module BooleanField::Fake
    extend ActiveSupport::Concern

    def generate_fake_value_to(record)
      record.write_attribute(name, Faker::Boolean.boolean)
    end
  end
end
