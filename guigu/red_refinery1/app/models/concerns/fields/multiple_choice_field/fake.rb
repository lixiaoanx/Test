# frozen_string_literal: true

module Fields
  module MultipleChoiceField::Fake
    extend ActiveSupport::Concern

    def generate_fake_value_to(record)
      ids = choices.map(&:id).shuffle.take(Faker::Number.between(from: 0, to: choices.size))
      ids.each do |id|
        record.read_attribute(name) << id
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
