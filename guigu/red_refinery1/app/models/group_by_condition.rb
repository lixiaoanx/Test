# frozen_string_literal: true

class GroupByCondition < ApplicationRecord
  belongs_to :custom_query
  belongs_to :field

  validates :field,
            uniqueness: { scope: :custom_query }
  validate :field_must_be_grouped_by

  private

    def field_must_be_grouped_by
      return unless field
      unless field.can_group_by?
        errors.add :field_id, :invalid
      end
    end
end
