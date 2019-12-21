# frozen_string_literal: true

class MemberGroup < ApplicationRecord
  belongs_to :group, counter_cache: :members_count
  belongs_to :member, optional: true
end
