# frozen_string_literal: true

class FieldFilterCondition < FilterCondition
  validates :field,
            presence: true

  def append_to(_query)
    raise NotImplementedError
  end
end

require_dependency "field_filter_conditions"
