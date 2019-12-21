# frozen_string_literal: true

module Fields
  class DateField < Field
    serialize :validations, Validations::DateField
    serialize :options, Options::DateField

    include Fields::DateField::Fake
    include Fields::DateField::Postgres
    include Fields::DateField::CustomQuery

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
