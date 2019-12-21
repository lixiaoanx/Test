# frozen_string_literal: true

module Fields::Validations
  class DateField < FieldOptions
    prepend Fields::Validations::Presence
    # prepend Fields::Validations::Uniqueness
  end
end
