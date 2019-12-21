# frozen_string_literal: true

class Transitions::ParallelSplit < Transition
  def on_fire(token, transaction_options, **options)
    token.completed!
    output_places.each do |p|
      next_token = p.tokens.create! previous: token, type: "Token",
                                    instance: token.instance, workflow: workflow,
                                    tenant: tenant, project: workflow.project
      auto_forward(next_token, transaction_options, options)
    end
  end

  def auto_forwardable?
    true
  end

  def internal?
    true
  end
end
