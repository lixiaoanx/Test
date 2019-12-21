# frozen_string_literal: true

module Fields
  module DatetimeField::Fake
    extend ActiveSupport::Concern

    def generate_fake_value_to(record)
      record.write_attribute(name, Faker::Time.forward(days: 365, period: :morning))
    end
  end
end
