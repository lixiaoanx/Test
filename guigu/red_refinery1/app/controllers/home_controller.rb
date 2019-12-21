# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @my_instances = WorkflowInstance.processing.where(creator: current_user.members).includes(:tenant, :project)
    @pending_tokens = Token.processing.where(assignable: current_user.members).includes(:tenant, :project, instance: [:workflow])
    @pending_observations = WorkflowInstanceObservation.where(read: false).where(observable: current_user.members).includes(instance: [:workflow])
  end
end
