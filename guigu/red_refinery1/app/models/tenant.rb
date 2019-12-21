# frozen_string_literal: true

class Tenant < ApplicationRecord
  belongs_to :creator, class_name: "User"

  has_many :members, dependent: :delete_all
  has_many :users, through: :members

  has_many :roles, dependent: :delete_all
  has_many :custom_roles
  has_one :owner_role
  has_one :member_role
  has_one :moderator_role

  has_many :trackers, class_name: "ProjectTracker"
  has_many :dictionaries
  has_many :projects
  has_many :forms
  has_many :metal_forms
  has_many :entries
  has_many :workflows
  has_many :workflow_instances

  validates :permalink,
            presence: true,
            uniqueness: true

  validates :name,
            presence: true

  validates :redmine_host, :redmine_secret, :redmine_database_url,
            presence: true

  after_create :auto_create_builtin!

  default_value_for :permalink,
                    ->(_) { SecureRandom.hex(3) },
                    allow_nil: false

  include RedmineConnectable

  def to_param
    permalink
  end

  def transfer_ownership!(to_user, force: false)
    raise "`to_user` can't be nil" unless to_user

    current_owner_member = owner_role.members.first
    transaction do
      member = members.find_by(user: to_user)
      if member
        member.role = owner_role
        member.save validate: false
      elsif force
        members.create! role: owner_role, user: to_user
      else
        raise "#{to_user.email} should be member first or set `force: true`"
      end

      if current_owner_member
        current_owner_member.role = member_role
        current_owner_member.save validate: false
      end
    end
  end

  private

    def auto_create_builtin!
      create_owner_role!
      create_member_role!
      create_moderator_role!

      # members.create(user: creator, role: owner_role)
    end
end
