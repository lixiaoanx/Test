# frozen_string_literal: true

class WorkflowAccessibility < ApplicationRecord
  belongs_to :workflow
  belongs_to :target, polymorphic: true
end
