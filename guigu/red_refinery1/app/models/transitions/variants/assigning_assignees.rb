# frozen_string_literal: true

module Transitions::Variants
  class AssigningAssignees < Transitions::Sequence
    serialize :options, Transitions::Options::AssigningAssignees

    def on_fire(token, transaction_options, **options)
      project = workflow.project
      token.update! processable: options.fetch(:current_user), status: :completed, hidden: true

      place = output_places.first # assume only one output place
      if self.options.assign_to_creator?
        next_token = place.tokens.create! assignable: token.instance.creator,
                                          previous: token, type: "Token",
                                          instance: token.instance, workflow: workflow,
                                          tenant: tenant, project: workflow.project
        auto_forward(next_token, transaction_options, options)
      elsif self.options.assign_to_specific?
        project.members.where(id: self.options.assignee_member_ids).each do |member|
          next_token = place.tokens.create! assignable: member,
                                            previous: token, type: "Token",
                                            instance: token.instance, workflow: workflow,
                                            tenant: tenant, project: workflow.project
          auto_forward(next_token, transaction_options, options)
        end

        project.groups.where(id: self.options.assignee_group_ids).each do |group|
          if ActiveModel::Type.lookup(:boolean).cast(self.options.expand_group)
            group.members.each do |member|
              next if member.user_id.blank?

              next_token = place.tokens.create! assignable: member,
                                                previous: token, type: "Token",
                                                instance: token.instance, workflow: workflow,
                                                tenant: tenant, project: workflow.project
              auto_forward(next_token, transaction_options, options)
            end
          else
            next_token = place.tokens.create! assignable: group,
                                              previous: token, type: "Token",
                                              instance: token.instance, workflow: workflow,
                                              tenant: tenant, project: workflow.project
            auto_forward(next_token, transaction_options, options)
          end
        end
      elsif self.options.assign_to_inherited?
        next_token = place.tokens.create! assignable: token.assignable,
                                          previous: token, type: "Token",
                                          instance: token.instance, workflow: workflow,
                                          tenant: tenant, project: workflow.project
        auto_forward(next_token, transaction_options, options)
      else
        raise "Unsupported assign to #{options.assign_to}"
      end
    end

    def auto_forwardable?
      true
    end

    def internal?
      true
    end
  end
end
