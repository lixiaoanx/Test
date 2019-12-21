# frozen_string_literal: true

class CustomQuery < ApplicationRecord
  belongs_to :tenant
  belongs_to :form

  has_many :filter_conditions, dependent: :destroy
  has_many :group_by_conditions, dependent: :delete_all
  has_many :aggregation_conditions, dependent: :delete_all

  validates :title,
            presence: true

  accepts_nested_attributes_for :filter_conditions,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes["field_id"].blank? || attributes["type"].blank? }
  accepts_nested_attributes_for :group_by_conditions,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes["field_id"].blank? }
  accepts_nested_attributes_for :aggregation_conditions,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes["aggregation"].blank? }

  AGG_COLUMN_REGEX = /\A__agg__(\w+)__(\w*)\z/
  UNNEST_COLUMN_REGEX = /\A__unnest__(\w+)\z/

  def to_query
    ar_model = form.pg_ar_class
    query = ar_model.all
    agg_results = []

    filter_conditions.each do |condition|
      query = condition.append_to(query)
    end

    aggregations = query

    # Group by
    group_by_field_names = group_by_conditions.map do |condition|
      field = form.fields.find { |f| f.id == condition.field_id }
      next unless field

      if field.array?
        aggregations = aggregations.select("UNNEST(#{field.name}) AS __unnest__#{field.name}").group("__unnest__#{field.name}")
      else
        aggregations = aggregations.select(field.name).group(field.name)
      end

      field.name.to_s
    end.compact

    # Aggregation
    aggregation_conditions.each do |condition|
      field = form.fields.find { |f| f.id == condition.field_id }
      next unless field

      aggregations = aggregations.select(
        "#{condition.aggregation}(#{field.name}) AS __agg__#{condition.aggregation}__#{field.name}"
      )

      if field.array? && group_by_field_names.exclude?(field.name.to_s)
        aggregations = aggregations.select("UNNEST(#{field.name}) AS __unnest__#{field.name}").group("__unnest__#{field.name}")
        group_by_field_names << field.name.to_s
      end
    end

    # Structuring aggregation result set
    if group_by_field_names.any? || aggregation_conditions.any?
      aggregations = aggregations.select("COUNT(*) AS __agg__count")

      agg_results = aggregations.map do |record|
        result = [[], 0, []] # field_names, count, aggregations

        record.attributes.except("id").each do |k, v|
          if k == "__agg__count"
            result[1] = v

            next
          end

          if k.start_with?("__agg__")
            matched = AGG_COLUMN_REGEX.match(k)
            next unless matched

            agg_name = matched[1]
            field_name = matched[2]

            result[2] << [field_name, agg_name, v]

            next
          end

          field_name =
            if UNNEST_COLUMN_REGEX.match(k)
              $1
            else
              k
            end

          if group_by_field_names.include?(field_name)
            result[0] << [field_name, v]
          end
        end

        result
      end
    end

    [query, agg_results]
  end
end
