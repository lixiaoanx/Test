# frozen_string_literal: true

require_relative "active_support/concern+prependable"

module ActiveSupport
  module Concern
    prepend Prependable
  end
end
