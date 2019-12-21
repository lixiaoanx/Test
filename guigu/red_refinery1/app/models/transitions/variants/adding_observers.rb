# frozen_string_literal: true

module Transitions::Variants
  class AddingObservers < Transitions::Sequence
    serialize :options, Transitions::Options::AddingObservers

    def on_fire(token, transaction_options, **options)
      project = workflow.project
      instance = token.instance
      token.update! processable: options.fetch(:current_user), status: :completed

      instance.tokens.where(workflow: workflow, place_id: token.place, status: "processing").update_all status: :terminated

      project.members.where(id: self.options.assignee_member_ids).each do |member|
        observation = instance.observations.find_or_create_by(workflow: workflow, observable: member)
        field_overrides = token.place.input_transition.options.try(:field_overrides)
        field_overrides&.each do |fo|
          efo = observation.options.field_overrides.find { |fo1| fo1.name == fo.name }
          if efo
            if efo.accessibility == :hidden
              efo.accessibility = fo.accessibility
            end
          else
            observation.options.field_overrides << fo
          end
        end

        observation.save
      end

      # project.groups.where(id: self.options.assignee_group_ids).each do |group|
      #   if self.options.expand_group
      #     group.members.each do |member|
      #       next if member.user_id.blank?
      #
      #       observation = instance.observations.find_or_create_by(observable: member)
      #       field_overrides = token.place.input_transition.options.try(:field_overrides)
      #       if field_overrides
      #         field_overrides.each do |fo|
      #           efo = observation.options.field_overrides.find { |fo1| fo1.name == fo.name }
      #           if efo
      #             if efo.accessibility == :hidden
      #               efo.accessibility = fo.accessibility
      #             end
      #           else
      #             observation.options.field_overrides << fo
      #           end
      #         end
      #       end
      #       observation.save
      #     end
      #   else
      #     observation = instance.observations.find_or_create_by(observable: group)
      #     field_overrides = token.place.input_transition.options.try(:field_overrides)
      #     if field_overrides
      #       field_overrides.each do |fo|
      #         efo = observation.options.field_overrides.find { |fo1| fo1.name == fo.name }
      #         if efo
      #           if efo.accessibility == :hidden
      #             efo.accessibility = fo.accessibility
      #           end
      #         else
      #           observation.options.field_overrides << fo
      #         end
      #       end
      #     end
      #     observation.save
      #   end
      # end

      place = output_places.first # assume only one output place
      next_token = place.tokens.create! assignable: token.assignable,
                                        previous: token, type: "Token",
                                        instance: token.instance, workflow: workflow,
                                        tenant: tenant, project: project
      auto_forward(next_token, transaction_options, options)
    end

    def auto_forwardable?
      true
    end

    def internal?
      true
    end
  end
end
