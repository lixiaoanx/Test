# frozen_string_literal: true

class OwnerRole < BuiltinRole
  validates :profiles,
            length: { is: 1 },
            if: :persisted?

  default_value_for :name, "builtin.roles.owner", allow_nil: false
end
