# frozen_string_literal: true

class Member < ApplicationRecord
  belongs_to :user, optional: true # User may not created

  belongs_to :tenant
  belongs_to :role
  has_many :member_groups
  has_many :groups, through: :member_groups

  validates :user,
            uniqueness: { scope: :tenant },
            allow_blank: true

  validates :redmine_user_id,
            presence: true,
            uniqueness: { scope: :tenant }

  default_value_for :role_id,
                    -> (member) {
                      if member.has_attribute?(:tenant_id) || member.tenant
                        member&.tenant&.member_role&.id
                      end
                    }, allow_nil: false

  def name
    user&.name || "RedmineUser##{redmine_user_id}"
  end

  def moderator?
    role.is_a?(ModeratorRole) || owner?
  end

  def owner?
    role.is_a? OwnerRole
  end

  def accessible?
    role.accessible?
  end
end
