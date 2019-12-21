# frozen_string_literal: true

module Fields
  module DecimalField::Fake
    extend ActiveSupport::Concern

    def generate_fake_value_to(record)
      record.write_attribute(name, Faker::Number.decimal(r_digits: 2))
    end
  end
end
