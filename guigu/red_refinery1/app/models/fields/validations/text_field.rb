# frozen_string_literal: true

module Fields::Validations
  class TextField < FieldOptions
    prepend Fields::Validations::Presence
    prepend Fields::Validations::Length
    prepend Fields::Validations::Format
    # prepend Fields::Validations::Uniqueness
  end
end
