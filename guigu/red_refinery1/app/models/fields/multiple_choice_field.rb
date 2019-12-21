# frozen_string_literal: true

module Fields
  class MultipleChoiceField < Field
    serialize :validations, Validations::MultipleChoiceField
    serialize :options, NonConfigurable

    include Fields::MultipleChoiceField::Fake
    include Fields::MultipleChoiceField::Postgres
    include Fields::MultipleChoiceField::CustomQuery

    def stored_type
      :integer
    end

    def attached_choices?
      true
    end

    def array?
      true
    end

    protected

      def interpret_extra_to(model, accessibility, overrides = {})
        return if accessibility != :read_and_write

        choice_ids = choices.pluck(:id)
        return if choice_ids.empty?

        model.validates name, subset: { in: choice_ids }, allow_blank: true
      end
  end
end
