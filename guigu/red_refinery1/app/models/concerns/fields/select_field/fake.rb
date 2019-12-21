# frozen_string_literal: true

module Fields
  module SelectField::Fake
    extend ActiveSupport::Concern

    def generate_fake_value_to(record)
      record.write_attribute(name, choices.sample&.label)
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
