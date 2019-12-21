# frozen_string_literal: true

class Redmine::Issue < RedmineRecord
  belongs_to :project, class_name: "Redmine::Project", foreign_key: "project_id"
  belongs_to :author, class_name: "Redmine::User", foreign_key: "author_id"
end
