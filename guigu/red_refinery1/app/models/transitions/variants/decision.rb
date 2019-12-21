# frozen_string_literal: true

module Transitions::Variants
  class Decision < Transitions::ExclusiveChoice
    serialize :options, Transitions::Options::Decision

    def on_fire(token, transaction_options, **options)
      if token.payload["decision"].blank?
        return
      end

      token.update! processable: options.fetch(:current_user), status: "completed"
      if self.options.one_vote_pass?
        token.instance.tokens.where(workflow: workflow, place_id: token.place, status: "processing").update_all status: :terminated, hidden: true

        next_place_id = token.payload["decision"] == "pass" ? self.options.pass_place_id : self.options.veto_place_id
        next_place = workflow.places.find(next_place_id)
        next_token = next_place.tokens.create! payload: token.payload,
                                               assignable: token.assignable,
                                               forwardable: token.forwardable,
                                               previous: token, type: "Token",
                                               instance: token.instance, workflow: workflow,
                                               tenant: tenant, project: workflow.project
        auto_forward(next_token, transaction_options, options)
      elsif self.options.one_vote_down?
        if token.payload["decision"] != "pass"
          token.instance.tokens.where(workflow: workflow, place_id: token.place, status: "processing").update_all status: :terminated

          next_place = workflow.places.find(self.options.veto_place_id)
          next_token = next_place.tokens.create! payload: token.payload,
                                                 assignable: token.assignable,
                                                 forwardable: token.forwardable,
                                                 previous: token, type: "Token",
                                                 instance: token.instance, workflow: workflow,
                                                 tenant: tenant, project: workflow.project
          auto_forward(next_token, transaction_options, options)
          return
        end

        if token.instance.tokens.all?(&:completed?)
          next_place = workflow.places.find(self.options.pass_place_id)
          next_token = next_place.tokens.create! payload: token.payload,
                                                 assignable: token.assignable,
                                                 forwardable: token.forwardable,
                                                 previous: token, type: "Token",
                                                 instance: token.instance, workflow: workflow,
                                                 tenant: tenant, project: workflow.project
          auto_forward(next_token, transaction_options, options)
        end
      else
        raise NotImplementedError, "Unknown vote rule #{self.options.vote_rule}"
      end
    end

    def auto_forwardable?
      false
    end

    def internal?
      false
    end
  end
end
