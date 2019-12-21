# frozen_string_literal: true

module Transitions::Variants
  class Choice < Transitions::ExclusiveChoice
    serialize :options, Transitions::Options::Choice

    def on_fire(token, transaction_options, **options)
      if token.payload["action"].blank?
        return
      end
      token.update! processable: options.fetch(:current_user), status: "completed", hidden: true
      token.instance.tokens.where(workflow: workflow, place_id: token.place, status: "processing").update_all status: :terminated

      next_place_id = self.options.actions.select do |action|
        token.payload["action"] == action.value
      end.first&.place_id
      raise "No suitable place id for action #{token.payload['action']}" unless next_place_id

      next_place = workflow.places.find(next_place_id)
      next_token = next_place.tokens.create! payload: token.payload,
                                             assignable: token.assignable,
                                             forwardable: token.forwardable,
                                             previous: token, type: "Token",
                                             instance: token.instance, workflow: workflow,
                                             tenant: tenant, project: workflow.project
      auto_forward(next_token, transaction_options, options)
    end

    def auto_forwardable?
      false
    end

    def internal?
      false
    end
  end
end
