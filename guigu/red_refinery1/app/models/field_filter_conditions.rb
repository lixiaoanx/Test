# frozen_string_literal: true

module FieldFilterConditions
  %w[
    boolean
  ].each do |type|
    require_dependency "field_filter_conditions/#{type}"
  end
end
