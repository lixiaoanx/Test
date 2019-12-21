# frozen_string_literal: true

class ApplicationView < ActiveRecord::Base
  self.abstract_class = true

  def readonly?
    true
  end
end
