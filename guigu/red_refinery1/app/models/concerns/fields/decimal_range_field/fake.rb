# frozen_string_literal: true

module Fields
  module DecimalRangeField::Fake
    extend ActiveSupport::Concern

    def generate_fake_value_to(record)
      range_record = record.association(name).build
      range_record.write_attribute("begin", Faker::Number.between(from: -65535.0, to: 0.0))
      range_record.write_attribute("end", Faker::Number.between(from: 1.0, to: 65535.0))
    end
  end
end
