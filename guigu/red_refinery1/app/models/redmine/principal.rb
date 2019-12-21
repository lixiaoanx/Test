# frozen_string_literal: true

class Redmine::Principal < RedmineRecord
  self.table_name = "users"

  # Account statuses
  STATUS_ANONYMOUS  = 0
  STATUS_ACTIVE     = 1
  STATUS_REGISTERED = 2
  STATUS_LOCKED     = 3

  scope :active, -> { where(status: STATUS_ACTIVE) }

  has_many :members, class_name: "Redmine::Member", foreign_key: "user_id", dependent: :destroy
  has_many :memberships,
           -> { joins(:project).where.not(projects: { status: Redmine::Project::STATUS_ARCHIVED }) },
           class_name: "Redmine::Member",
           foreign_key: "user_id"
  has_many :projects, class_name: "Redmine::Project", through: :memberships
end
