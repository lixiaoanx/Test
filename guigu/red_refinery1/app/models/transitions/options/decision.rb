# frozen_string_literal: true

module Transitions::Options
  class Decision < FieldOptions
    include FieldOverridable
    include Votable

    attribute :pass_place_id, :integer
    attribute :veto_place_id, :integer
  end
end
