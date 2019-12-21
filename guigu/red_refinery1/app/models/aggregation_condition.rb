# frozen_string_literal: true

class AggregationCondition < ApplicationRecord
  belongs_to :custom_query
  belongs_to :field

  validate :field_must_support_aggregation
  validates :aggregation,
            presence: true,
            uniqueness: { scope: [:custom_query, :field] }

  private

    def field_must_support_aggregation
      return unless field

      unless field.can_aggregation?
        errors.add :field_id, :invalid
        return
      end

      unless field.supported_aggregations.include? aggregation
        errors.add :field_id, :inclusion, value: aggregation
      end
    end
end
