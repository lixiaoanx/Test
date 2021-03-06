# frozen_string_literal: true

module Fields
  module TextField::Fake
    extend ActiveSupport::Concern

    def generate_fake_value_to(record)
      record.write_attribute(name, Faker::Lorem.sentence)
    end
  end
end
