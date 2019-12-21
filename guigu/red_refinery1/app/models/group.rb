# frozen_string_literal: true

class Group < ApplicationRecord
  include ActsAsPgTree

  belongs_to :tenant
  belongs_to :project

  belongs_to :parent, class_name: "Group", optional: true, counter_cache: :children_count
  has_many :children, class_name: "Group", foreign_key: "parent_id"

  has_many :member_groups
  has_many :members, through: :member_groups

  def builtin?
    false
  end

  # 获取一个组的成员以及下级所有组的成员
  def all_members
    Member.joins(member_groups: :group).merge(Group.descendants_of_with_self(self))
  end
end
