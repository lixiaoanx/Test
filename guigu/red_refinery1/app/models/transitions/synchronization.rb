# frozen_string_literal: true

class Transitions::Synchronization < Transition
  def on_fire(token, transaction_options, **options)
    p = output_places.first # assume only one output place
    # return unless p.tokens.size.zero?

    token.completed!
    # TODO: consider if status are not completed
    completed_tokens =
      input_places
      .includes(:tokens).where(workflow_tokens: { instance_id: token.instance_id })
      .map(&:tokens).flatten.select(&:completed?)
    if completed_tokens.size == input_places.size
      next_token = p.tokens.create! previous: token, type: "Token",
                                    instance: token.instance, workflow: workflow,
                                    tenant: tenant, project: workflow.project
      auto_forward(next_token, transaction_options, options)
    end
  end

  def auto_forwardable?
    true
  end

  def options_configurable?
    false
  end

  def internal?
    true
  end
end
