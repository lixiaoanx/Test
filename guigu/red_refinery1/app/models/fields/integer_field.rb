# frozen_string_literal: true

module Fields
  class IntegerField < Field
    serialize :validations, Validations::IntegerField
    serialize :options, Options::IntegerField

    include Fields::IntegerField::Fake
    include Fields::IntegerField::Postgres
    include Fields::IntegerField::CustomQuery

    def stored_type
      :integer
    end

    def can_act_as_evaluatable?
      true
    end

    protected

      def interpret_extra_to(model, accessibility, _overrides = {})
        return if accessibility != :read_and_write

        model.validates name, numericality: { only_integer: true }, allow_blank: true
      end
  end
end
