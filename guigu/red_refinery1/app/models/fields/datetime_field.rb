# frozen_string_literal: true

module Fields
  class DatetimeField < Field
    serialize :validations, Validations::DatetimeField
    serialize :options, Options::DatetimeField

    include Fields::DatetimeField::Fake
    include Fields::DatetimeField::Postgres
    include Fields::DatetimeField::CustomQuery

    def stored_type
      :datetime
    end

    def can_act_as_evaluatable?
      true
    end

    protected

      def interpret_extra_to(model, accessibility, overrides = {})
        model.class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{name}=(val)
          super(val.try(:in_time_zone)&.utc)
        end
        CODE
      end
  end
end
