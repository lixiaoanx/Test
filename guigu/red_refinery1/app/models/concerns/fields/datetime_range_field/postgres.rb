# frozen_string_literal: true

module Fields
  module DatetimeRangeField::Postgres
    extend ActiveSupport::Concern

    def pg_type
      "tsrange"
    end

    def pg_encode(virtual_record, entry)
      range = virtual_record.association(name).target
      return unless range

      if range.begin.blank?
        raise "Field #{id} begin value can't be nil because Ruby's Range doesn't"
      end

      entry.data[id.to_s] =
        [
          "[#{::ApplicationRecord.connection.quote(range.begin)}",
          range.end.present? ? "#{::ApplicationRecord.connection.quote(range.end)})" : "Infinity)"
        ].join(",")
    end

    def pg_decode(entry, virtual_record)
      return unless entry.data[id.to_s]

      caster = ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Range.new(ActiveRecord::Type.lookup(:datetime))
      range = caster.cast entry.data[id.to_s]

      virtual_record.association(name).build begin: range.begin, end: range.end
    end
  end
end
