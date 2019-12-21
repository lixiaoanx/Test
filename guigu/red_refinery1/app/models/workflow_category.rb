# frozen_string_literal: true

class WorkflowCategory < ApplicationRecord
  belongs_to :tenant
  belongs_to :project

  has_many :workflows, foreign_key: "category_id"
end
