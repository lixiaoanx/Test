# frozen_string_literal: true

module Fields::Validations
  class SelectField < FieldOptions
    prepend Fields::Validations::Presence
    # prepend Fields::Validations::Uniqueness
  end
end
