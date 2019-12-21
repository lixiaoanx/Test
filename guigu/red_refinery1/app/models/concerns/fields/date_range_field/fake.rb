# frozen_string_literal: true

module Fields
  module DateRangeField::Fake
    extend ActiveSupport::Concern

    def generate_fake_value_to(record)
      range_record = record.association(name).build
      range_record.write_attribute("begin", Faker::Date.between(from: Date.today, to: 128.days.since))
      range_record.write_attribute("end", Faker::Date.between(from: 129.days.since, to: 365.days.since))
    end
  end
end
