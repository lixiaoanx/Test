# frozen_string_literal: true

class MemberRole < BuiltinRole
  default_value_for :name, "builtin.roles.member", allow_nil: false
end
