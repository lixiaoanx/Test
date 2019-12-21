# frozen_string_literal: true

module Transitions::Options
  module Assignable
    extend ActiveSupport::Concern

    included do
      attribute :assignee_member_ids, type: :string, array: true
      attribute :assignee_group_ids, type: :string, array: true
      attribute :assign_to, type: :string, default: "creator"
      attribute :expand_group, type: :boolean, default: false

      enum assign_to: {
        creator: "creator",
        specific: "specific",
        inherited: "inherited"
      }, _prefix: :assign_to

      validates :assign_to,
                presence: true
    end
  end
end
