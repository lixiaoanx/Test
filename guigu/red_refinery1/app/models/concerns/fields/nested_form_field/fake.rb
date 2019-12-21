# frozen_string_literal: true

module Fields
  module NestedFormField::Fake
    extend ActiveSupport::Concern

    def generate_fake_value_to(record)
      nested_record = record.association(name).build
      nested_form.fields.each do |f|
        f.generate_fake_value_to(nested_record)
      end
    end
  end
end
