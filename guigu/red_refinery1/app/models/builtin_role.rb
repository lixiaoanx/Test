# frozen_string_literal: true

class BuiltinRole < Role
  attr_readonly :name

  def name
    I18n.t(self[:name])
  end
end
