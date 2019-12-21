# frozen_string_literal: true

module Fields
  class DateRangeField < Field
    serialize :validations, Validations::DateRangeField
    serialize :options, Options::DateRangeField

    include Fields::DateRangeField::Fake
    include Fields::DateRangeField::Postgres

    protected

      def interpret_attribute_to(model, accessibility, overrides = {})
        nested_model = Class.new(Fields::Embeds::DateRange)
        model.nested_models[name] = nested_model

        model.embeds_one name, anonymous_class: nested_model, validate: true
        model.accepts_nested_attributes_for name, reject_if: :all_blank

        if accessibility == :readonly
          model.attr_readonly name
        end
      end
  end
end
