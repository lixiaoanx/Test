# frozen_string_literal: true

module FieldFilterConditions
  class Integer < FieldFilterCondition
    class Options < FieldFilterOptions
      attribute :operator, :string
      enum operator: {
        eq: "eq",
        not_eq: "not_eq",
        gt: "gt",
        gteq: "gteq",
        lt: "lt",
        lteq: "lteq"
      }
      attribute :value, :integer
    end

    serialize :options, Options
    delegate_missing_to :options

    def append_to(query)
      if options.null_value?
        return query.where(field.name => nil)
      end

      return query unless options.value.present?

      if options.eq?
        query.where(field.name => options.value)
      elsif options.not_eq?
        query.where.not(field.name => options.value)
      elsif options.gt?
        query.where("#{::ApplicationRecord.connection.quote_column_name(field.name)} > ?", options.value)
      elsif options.gteq?
        query.where("#{::ApplicationRecord.connection.quote_column_name(field.name)} >= ?", options.value)
      elsif options.lt?
        query.where("#{::ApplicationRecord.connection.quote_column_name(field.name)} < ?", options.value)
      elsif options.lteq?
        query.where("#{::ApplicationRecord.connection.quote_column_name(field.name)} <= ?", options.value)
      end
    end
  end
end
