# frozen_string_literal: true

module Fields
  module Postgres
    extend ActiveSupport::Concern

    included do
      # TODO fix table name change
      after_create do
        form.pg_create_or_replace_view!
      end

      after_update do
        form.pg_create_or_replace_view!
      end

      after_destroy do
        form.pg_create_or_replace_view!
      end
    end

    def pg_type
      raise NotImplementedError
    end

    def pg_encode(virtual_record, entry)
      value = virtual_record.read_attribute(name)
      return unless value
      entry.data[id.to_s] = value
    end

    def pg_decode(entry, to_virtual_record)
      return unless entry.data[id.to_s]

      to_virtual_record.write_attribute(
        name,
        ActiveEntity::Type.lookup(stored_type).cast(entry.data[id.to_s])
      )
    end

    def pg_array_type?
      pg_type.end_with?("[]")
    end

    def pg_text_type?
      pg_type == "text"
    end

    def pg_range_type?
      pg_type =~ /range(\[\])?$/
    end

    def pg_btree_index?
      return false if pg_array_type?
      return false if pg_range_type?
      return false if pg_text_type?
      true
    end

    def pg_gin_index?
      # TODO:
    end

    def pg_fulltext_index?
      pg_text_type?
    end

    def pg_row_key
      ::ApplicationRecord.connection.quote(id.to_s)
    end

    def pg_index_name(idx_type = "btree")
      ::ApplicationRecord.connection.quote_column_name([form_id, idx_type, id, name].join("_"))
    end

    # TODO gin or fulltext
    def pg_index_expression
      if pg_btree_index?
        <<~SQL
        CREATE INDEX CONCURRENTLY IF NOT EXISTS #{index_name}
        ON entries
        USING BTREE (form_id, CAST ((data ->> #{pg_row_key}) AS #{pg_type})
        WHERE form_id = #{form_id}
        SQL
      end
    end

    def pg_expression
      "(CAST (data ->> #{pg_row_key} AS #{pg_type})) AS #{::ApplicationRecord.connection.quote_column_name(name)}"
    end

    def pg_create_index!
      ::ApplicationRecord.connection.execute(pg_index_expression) if pg_index_expression
    end

    def pg_drop_index!
      ::ApplicationRecord.connection.execute("DROP INDEX IF EXISTS #{pg_index_name}")
    end
  end
end
