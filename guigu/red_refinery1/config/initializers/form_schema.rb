# frozen_string_literal: true

ApplicationRecord.connection.execute "CREATE SCHEMA IF NOT EXISTS #{ApplicationRecord.connection.quote_schema_name("form_views")}" rescue ActiveRecord::NoDatabaseError
