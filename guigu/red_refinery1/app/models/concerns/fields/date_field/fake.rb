# frozen_string_literal: true

module Fields
  module DateField::Fake
    extend ActiveSupport::Concern

    def generate_fake_value_to(record)
      record.write_attribute(name, Faker::Date.forward(days: 365))
    end
  end
end
