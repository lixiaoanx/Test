# frozen_string_literal: true

module Fields
  class BooleanField < Field
    serialize :validations, Validations::BooleanField
    serialize :options, NonConfigurable

    include Fields::BooleanField::Fake
    include Fields::BooleanField::Postgres
    include Fields::BooleanField::CustomQuery

    def stored_type
      :boolean
    end

    def can_act_as_evaluatable?
      true
    end
  end
end
