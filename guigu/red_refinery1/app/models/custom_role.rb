# frozen_string_literal: true

class CustomRole < Role
  validates :name,
            presence: true,
            uniqueness: { scope: :tenant }
end
