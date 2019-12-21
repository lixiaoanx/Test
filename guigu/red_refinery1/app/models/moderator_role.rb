# frozen_string_literal: true

class ModeratorRole < BuiltinRole
  default_value_for :name, "builtin.roles.moderator", allow_nil: false
end
