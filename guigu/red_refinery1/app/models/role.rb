# frozen_string_literal: true

class Role < ApplicationRecord
  belongs_to :tenant
  has_many :members

  validates :name,
            presence: true

  def accessible?
    true
  end
end
