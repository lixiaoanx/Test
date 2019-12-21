# frozen_string_literal: true

class Entry < ApplicationRecord
  belongs_to :tenant
  belongs_to :project

  belongs_to :form, class_name: "MetalForm", foreign_key: "form_id"

  has_many :children, class_name: "Entry", foreign_key: "parent_id", dependent: :destroy, autosave: true
  belongs_to :parent, class_name: "Entry", optional: true

  scope :with_children, -> { includes(:children) }
end
