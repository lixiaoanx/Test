# frozen_string_literal: true

module InstancesHelper
  def render_instances_table(instances = [], options = {})
    render "shared/instances_table", instances: instances, options: options
  end
end
