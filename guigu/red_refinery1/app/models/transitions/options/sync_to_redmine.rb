# frozen_string_literal: true

module Transitions::Options
  class SyncToRedmine < FieldOptions
    attribute :start_date_field_name, :string
    attribute :due_date_field_name, :string
    attribute :estimated_hours_field_name, :string
    attribute :done_ratio_field_name, :string
    attribute :notes_field_name, :string
  end
end
