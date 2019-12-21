# frozen_string_literal: true

module FieldFilterConditions
  class Boolean < FieldFilterCondition
    class Options < FieldFilterOptions
      attribute :match, :string
      enum match: {
        true_value: "true_value",
        false_value: "false_value"
      }
    end

    serialize :options, Options
    delegate_missing_to :options

    def append_to(query)
      value =
        if options.null_value?
          nil
        elsif options.true_value?
          true
        elsif options.false_value?
          false
        end

      query.where(field.name => value)
    end
  end
end
