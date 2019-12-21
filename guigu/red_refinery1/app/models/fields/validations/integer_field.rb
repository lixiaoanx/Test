# frozen_string_literal: true

module Fields::Validations
  class IntegerField < FieldOptions
    prepend Fields::Validations::Presence
    prepend Fields::Validations::Numericality
    # prepend Fields::Validations::Uniqueness
  end
end
