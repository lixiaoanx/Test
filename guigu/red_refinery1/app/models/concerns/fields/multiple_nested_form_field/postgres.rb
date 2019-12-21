# frozen_string_literal: true

module Fields
  module MultipleNestedFormField::Postgres
    extend ActiveSupport::Concern

    def pg_encode(virtual_record, entry)
      return if accessibility == :hidden

      nested_records = virtual_record.association(name).target
      return unless nested_records.any?

      nested_records.each do |nested_record|
        child_entry = entry.children.build
        nested_form.prepare_entry(child_entry, nested_record)
      end
    end

    def pg_decode(entry, virtual_record)
      entry.children.where(form_id: nested_form.id).each do |nested_entry|
        nested_record = virtual_record.association(name).build
        nested_form.load_entry_to(nested_record, nested_entry)
      end
    end
  end
end
