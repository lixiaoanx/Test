# frozen_string_literal: true

module Forms
  module Postgres
    extend ActiveSupport::Concern

    included do
      # TODO fix table name change
      after_create :pg_create_or_replace_view!
      after_destroy :pg_drop_view!
    end

    def pg_definition
      selects =
        %w[id created_at updated_at form_id tenant_id] +
        fields
          .reject { |f| f.class.in? [::Fields::MultipleNestedFormField, ::Fields::NestedFormField] }
          .map(&:pg_expression)

      <<~SQL
      SELECT #{selects.join(", ")} FROM #{::ApplicationRecord.connection.quote_table_name(::Entry.table_name)} WHERE form_id = #{id}
      SQL
    end

    def pg_view_definition
      <<~SQL
      CREATE OR REPLACE VIEW #{pg_view_name} AS (
        #{pg_definition}
      )
      SQL
    end

    def pg_view_schema
      "form_views"
    end

    def pg_view_name
      [::ApplicationRecord.connection.quote_table_name(pg_view_schema), ::ApplicationRecord.connection.quote_table_name(name)].join(".")
    end

    def pg_drop_view!
      ::ApplicationRecord.connection.execute("DROP VIEW IF EXISTS #{pg_view_name}")
    end

    def pg_create_or_replace_view!
      pg_drop_view!
      ::ApplicationRecord.connection.execute(pg_view_definition)
    end

    def pg_ar_class
      klass = Class.new(::ApplicationView)
      klass.table_name = pg_view_name
      klass.primary_key = :id
      klass
    end

    def pg_rows_from_view
      pg.query_hash("select * from #{pg_view_name}")
    end
  end
end
