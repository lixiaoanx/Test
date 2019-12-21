# frozen_string_literal: true

class WorkflowVisibility < ApplicationRecord
  belongs_to :workflow
  belongs_to :target, polymorphic: true
end
