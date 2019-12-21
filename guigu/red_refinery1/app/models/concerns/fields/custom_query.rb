# frozen_string_literal: true

module Fields
  module CustomQuery
    extend ActiveSupport::Concern

    def filter_class
      nil
    end

    def can_filter?
      filter_class
    end

    def can_group_by?
      false
    end

    def array?
      false
    end

    def supported_aggregations
      %w[]
    end

    def can_aggregation?
      supported_aggregations.any?
    end
  end
end
