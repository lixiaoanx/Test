# frozen_string_literal: true

module Fields
  class DecimalField < Field
    serialize :validations, Validations::DecimalField
    serialize :options, Options::DecimalField

    include Fields::DecimalField::Fake
    include Fields::DecimalField::Postgres
    include Fields::DecimalField::CustomQuery

    def stored_type
      :decimal
    end

    def can_act_as_evaluatable?
      true
    end
  end
end
