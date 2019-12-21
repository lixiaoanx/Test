# frozen_string_literal: true

class ProjectTracker < ApplicationRecord
  belongs_to :tenant
  belongs_to :project
  belongs_to :workflow

  validates :redmine_tracker_id,
            presence: true,
            uniqueness: {
              scope: :project
            }
end
