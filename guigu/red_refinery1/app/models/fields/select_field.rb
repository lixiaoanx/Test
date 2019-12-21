# frozen_string_literal: true

module Fields
  class SelectField < Field
    serialize :validations, Validations::SelectField
    serialize :options, Options::SelectField

    include Fields::SelectField::Fake
    include Fields::SelectField::Postgres
    include Fields::SelectField::CustomQuery

    def stored_type
      :string
    end

    def attached_choices?
      true
    end

    protected

      def interpret_extra_to(model, accessibility, overrides = {})
        return if accessibility != :read_and_write || !options.strict_select

        model.validates name, inclusion: { in: choices.pluck(:label) }, allow_blank: true
      end
  end
end
