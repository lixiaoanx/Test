# frozen_string_literal: true

module Transitions::Options
  class AddingObservers < FieldOptions
    attribute :assignee_member_ids, type: :string, array: true
    # attribute :assignee_group_ids, type: :string, array: true
    # attribute :expand_group, type: :boolean, default: true
  end
end
