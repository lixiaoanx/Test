# frozen_string_literal: true

class DefaultGroup < Group
  attr_readonly :name

  def name
    I18n.t(self[:name])
  end

  def builtin?
    true
  end
end
