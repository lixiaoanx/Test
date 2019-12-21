# frozen_string_literal: true

class Redmine::Member < RedmineRecord
  belongs_to :user, class_name: "Redmine::User", foreign_key: "user_id"
  belongs_to :principal, class_name: "Redmine::Principal", foreign_key: "user_id"

  belongs_to :project, class_name: "Redmine::Project", foreign_key: "project_id"
end
