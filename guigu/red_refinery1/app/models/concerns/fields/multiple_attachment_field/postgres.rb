# frozen_string_literal: true

module Fields
  module MultipleAttachmentField::Postgres
    extend ActiveSupport::Concern

    def pg_type
      "bigint[]"
    end

    def pg_encode(virtual_record, entry)
      entry.data[id.to_s] = PG::TextEncoder::Array.new.encode(virtual_record.read_attribute(name))&.force_encoding("UTF-8")
    end

    def pg_decode(entry, virtual_record)
      return unless entry.data[id.to_s]

      virtual_record.write_attribute(
        name,
        PG::TextDecoder::Array.new.decode(entry.data[id.to_s])
      )
    end
  end
end
