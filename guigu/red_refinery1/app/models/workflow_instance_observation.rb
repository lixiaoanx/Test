# frozen_string_literal: true

class WorkflowInstanceObservation < ApplicationRecord
  belongs_to :project
  belongs_to :workflow
  belongs_to :instance, class_name: "WorkflowInstance"
  belongs_to :observable, polymorphic: true
  belongs_to :granted_by, polymorphic: true, optional: true

  serialize :options, WorkflowInstanceObservationOptions
end
