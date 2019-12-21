# frozen_string_literal: true

module FieldFilterConditions
  class MultipleChoice < FieldFilterCondition
    class Options < FieldFilterOptions
      attribute :operator, :string
      enum operator: {
        eq: "eq",
        not_eq: "not_eq",
        cont: "cont",
        not_cont: "not_cont"
      }
      attribute :values, :integer, array_without_blank: true
    end

    serialize :options, Options

    def append_to(query)
      if options.null_value?
        return query.where(field.name => nil)
      end

      if options.eq?
        query.where(field.name => options.values)
      elsif options.not_eq?
        query.where.not(field.name => options.values)
      elsif options.cont?
        query.where(
          "#{::ApplicationRecord.connection.quote_column_name(field.name)} @> ?",
          PG::TextEncoder::Array.new.encode(options.values)&.force_encoding("UTF-8")
        )
      elsif options.not_cont?
        query.where(
          "NOT (#{::ApplicationRecord.connection.quote_column_name(field.name)} @> ?)",
          PG::TextEncoder::Array.new.encode(options.values)&.force_encoding("UTF-8")
        )
      end
    end
  end
end
