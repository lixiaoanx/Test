# frozen_string_literal: true

module Fields
  module MultipleSelectField::Fake
    extend ActiveSupport::Concern

    def generate_fake_value_to(record)
      values = choices.map(&:label).shuffle.take(Faker::Number.between(from: 0, to: choices.size))
      values.each do |value|
        record.read_attribute(name) << value
      end
    end

    module ClassMethods
      def configure_fake_options_to(field)
        field.choices.build label: Faker::Artist.name
        field.choices.build label: Faker::Artist.name
        field.choices.build label: Faker::Artist.name
        field.choices.build label: Faker::Artist.name
      end
    end
  end
end
