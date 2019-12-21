# frozen_string_literal: true

module Fields
  module NestedFormField::Postgres
    extend ActiveSupport::Concern

    def pg_encode(virtual_record, entry)
      return if accessibility == :hidden

      nested_record = virtual_record.association(name).target
      return unless nested_record

      child_entry = entry.children.build
      nested_form.prepare_entry(child_entry, nested_record)
    end

    def pg_decode(entry, virtual_record)
      nested_entry = entry.children.where(form_id: nested_form.id).first
      return unless nested_entry

      nested_record = virtual_record.association(name).build
      nested_form.load_entry_to(nested_record, nested_entry)
    end
  end
end
