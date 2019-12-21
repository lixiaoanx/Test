# frozen_string_literal: true

module Transitions::Variants
  class SyncToRedmine < Transitions::Sequence
    serialize :options, Transitions::Options::SyncToRedmine

    def on_fire(token, transaction_options, **options)
      instance = token.instance

      # TODO: Time entry
      if token.instance.redmine_issue_id.present? && instance.creator.try(:redmine_user_id).present?
        issue_params = {}

        if self.options.start_date_field_name.present?
          issue_params[:start_date] =
            begin
              value = instance.payload[self.options.start_date_field_name]
              if value.is_a?(Hash)
                value = value.with_indifferent_access
                value[:begin].to_date if value.has_key?(:begin)
              else
                value.to_date
              end
            end
        end
        if self.options.due_date_field_name.present?
          issue_params[:due_date] =
            begin
              value = instance.payload[self.options.start_date_field_name]
              if value.is_a?(Hash)
                value = value.with_indifferent_access
                value[:end].to_date if value.has_key?(:end)
              else
                value.to_date
              end
            end
        end
        if self.options.estimated_hours_field_name.present?
          issue_params[:estimated_hours] = instance.payload[self.options.estimated_hours_field_name]
        end
        if self.options.done_ratio_field_name.present?
          issue_params[:done_ratio] = instance.payload[self.options.done_ratio_field_name]
        end
        if self.options.notes_field_name.present?
          issue_params[:notes] = instance.payload[self.options.notes_field_name]
        end

        if issue_params.any?
          tenant.redmine_api_client.update_issue(
            user_id: instance.creator.redmine_user_id,
            issue_id: token.instance.redmine_issue_id,
            issue_params: issue_params
          )
        end
      end

      token.update! status: "completed"
      token.instance.tokens.where(workflow: workflow, place_id: token.place, status: "processing").update_all status: :terminated

      place = output_places.first # assume only one output place
      next_token = place.tokens.create! assignable: token.assignable,
                                        previous: token, type: "Token",
                                        instance: token.instance, workflow: workflow,
                                        tenant: tenant, project: workflow.project
      auto_forward(next_token, transaction_options, options)
    end

    def internal?
      true
    end

    def auto_forwardable?
      true
    end
  end
end
