# frozen_string_literal: true

class Dictionary < ApplicationRecord
  SCOPE_REGEX = /\A([a-z_][a-z_0-9]*\.)*[a-z_][a-z_0-9]*\z/.freeze

  belongs_to :tenant

  attribute :value, :string
  validates :value,
            presence: true, uniqueness: { scope: :scope }

  validates :scope,
            presence: true,
            format: { with: SCOPE_REGEX }
end
