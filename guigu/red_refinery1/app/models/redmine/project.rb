# frozen_string_literal: true

class Redmine::Project < RedmineRecord
  # Project statuses
  STATUS_ACTIVE     = 1
  STATUS_CLOSED     = 5
  STATUS_ARCHIVED   = 9

  has_many :issues, class_name: "Redmine::Issue", foreign_key: "issue_id"

  has_many :memberships, class_name: "Redmine::Member", inverse_of: :project
  # Memberships of active users only
  has_many :members,
           lambda { joins(:principal).where(users: { type: "User", status: ::Redmine::Principal::STATUS_ACTIVE }) }
end
