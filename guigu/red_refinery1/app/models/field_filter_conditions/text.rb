# frozen_string_literal: true

module FieldFilterConditions
  class Text < FieldFilterCondition
    class Options < FieldFilterOptions
      attribute :operator, :string
      enum operator: {
        eq: "eq",
        not_eq: "not_eq",
        cont: "cont",
        not_cont: "not_cont",
        start: "start",
        end: "end"
      }
      attribute :value, :text
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
      elsif options.cont?
        query.where("#{::ApplicationRecord.connection.quote_column_name(field.name)} LIKE %?%", options.value)
      elsif options.not_cont?
        query.where("#{::ApplicationRecord.connection.quote_column_name(field.name)} NOT LIKE %?%", options.value)
      elsif options.start?
        query.where("#{::ApplicationRecord.connection.quote_column_name(field.name)} NOT LIKE %?", options.value)
      elsif options.end?
        query.where("#{::ApplicationRecord.connection.quote_column_name(field.name)} NOT LIKE ?%", options.value)
      end
    end
  end
end
