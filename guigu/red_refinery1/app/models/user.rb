# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, :confirmable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable, :invitable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :members, dependent: :destroy
  has_many :member_groups, through: :members
  has_many :groups, through: :member_groups
  has_many :projects, -> { distinct }, through: :groups
  has_many :tenants, through: :members

  scope :active, -> { where(locked_at: nil) }

  def admin?
    email.in? Settings.admin.emails
  end

  def name
    full_name || email
  end

  def member_of(tenant:)
    tenant.members.find_by user: self
  end

  # Failsafe when disabled confirmable
  def confirmed?
    if defined? super
      super
    else
      true
    end
  end

  def pending_reconfirmation?
    if defined? super
      super
    else
      false
    end
  end
end
