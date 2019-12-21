# frozen_string_literal: true

module Fields
  class DatetimeRangeField < Field
    serialize :validations, Validations::DatetimeRangeField
    serialize :options, Options::DatetimeRangeField

    include Fields::DatetimeRangeField::Fake
    include Fields::DatetimeRangeField::Postgres

    protected

      def interpret_attribute_to(model, accessibility, overrides = {})
        nested_model = Class.new(Fields::Embeds::DatetimeRange)
        model.nested_models[name] = nested_model

        model.embeds_one name, anonymous_class: nested_model, validate: true
        model.accepts_nested_attributes_for name, reject_if: :all_blank
        if accessibility == :readonly
          model.attr_readonly name
        end
      end
  end
end
