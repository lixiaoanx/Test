# frozen_string_literal: true

module Fields
  class MultipleSelectField < Field
    serialize :validations, Validations::MultipleSelectField
    serialize :options, Options::MultipleSelectField

    include Fields::MultipleSelectField::Fake
    include Fields::MultipleSelectField::Postgres
    include Fields::MultipleSelectField::CustomQuery

    def stored_type
      :string
    end

    def attached_choices?
      true
    end

    def array?
      true
    end

    protected

      def interpret_extra_to(model, accessibility, overrides = {})
        return if accessibility != :read_and_write || !options.strict_select

        model.validates name, subset: { in: choices.pluck(:label) }, allow_blank: true
      end
  end
end
