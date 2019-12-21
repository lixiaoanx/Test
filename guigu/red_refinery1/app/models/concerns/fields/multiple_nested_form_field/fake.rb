# frozen_string_literal: true

module Fields
  module MultipleNestedFormField::Fake
    extend ActiveSupport::Concern

    def generate_fake_value_to(record)
      nested_records = Faker::Number.between(from: 0, to: 8).times.map { record.association(name).build }
      nested_records.each do |r|
        nested_form.fields.each do |f|
          f.generate_fake_value_to(r)
        end
      end
    end
  end
end
