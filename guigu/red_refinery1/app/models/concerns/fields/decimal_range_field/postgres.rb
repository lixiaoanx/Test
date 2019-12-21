# frozen_string_literal: true

module Fields
  module DecimalRangeField::Postgres
    extend ActiveSupport::Concern

    def pg_type
      "numrange"
    end

    def pg_encode(virtual_record, entry)
      range = virtual_record.association(name).target
      return unless range

      if range.begin.blank? || range.end.blank?
        raise "Field #{id} mapping to `#{pg_type}` which doesn't support `Infinity`"
      end

      entry.data[id.to_s] =
        "[#{::ApplicationRecord.connection.quote(range.begin)},#{::ApplicationRecord.connection.quote(range.end)})"
    end

    def pg_decode(entry, virtual_record)
      return unless entry.data[id.to_s]

      caster = ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Range.new(ActiveRecord::Type.lookup(:decimal))
      range = caster.cast entry.data[id.to_s]

      virtual_record.association(name).build begin: range.begin, end: range.end
    end
  end
end
