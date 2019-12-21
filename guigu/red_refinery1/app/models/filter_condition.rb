# frozen_string_literal: true

class FilterCondition < ApplicationRecord
  belongs_to :custom_query

  belongs_to :field, optional: true

  def self.type_key
    model_name.name.demodulize.underscore.to_sym
  end

  def type_key
    self.class.type_key
  end
end
