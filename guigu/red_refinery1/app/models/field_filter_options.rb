# frozen_string_literal: true

class FieldFilterOptions < FieldOptions
  attribute :value_status, :boolean, default: false
  enum null_value: {
    null: "null",
    not_null: "not_null"
  }, _suffix: "value"
end
