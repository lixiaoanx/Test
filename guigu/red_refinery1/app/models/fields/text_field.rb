# frozen_string_literal: true

module Fields
  class TextField < Field
    serialize :validations, Validations::TextField
    serialize :options, Options::TextField

    include Fields::TextField::Fake
    include Fields::TextField::Postgres
    include Fields::TextField::CustomQuery

    def stored_type
      :string
    end

    def can_act_as_evaluatable?
      true
    end
  end
end
