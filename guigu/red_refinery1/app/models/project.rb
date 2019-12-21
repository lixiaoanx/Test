# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :tenant

  has_many :trackers, class_name: "ProjectTracker", dependent: :delete_all
  has_many :groups, dependent: :destroy
  has_many :custom_groups
  has_one :default_group
  has_many :members, -> { distinct }, through: :groups

  has_many :forms
  has_many :metal_forms
  has_many :entries
  has_many :workflow_categories
  has_many :workflows
  has_many :workflow_instances
  has_many :tokens
  has_many :workflow_instance_observations

  validates :name,
            presence: true

  validates :redmine_project_id,
            presence: true,
            uniqueness: {
              scope: :tenant
            }

  after_create :auto_create_builtin!

  private

    def auto_create_builtin!
      create_default_group! tenant: tenant, name: "builtin.groups.default"
    end
end
