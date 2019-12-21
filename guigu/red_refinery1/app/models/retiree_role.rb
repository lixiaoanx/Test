# frozen_string_literal: true

class RetireeRole < BuiltinRole
  default_value_for :name, "builtin.roles.retiree", allow_nil: false

  def accessible?
    true
  end
end
