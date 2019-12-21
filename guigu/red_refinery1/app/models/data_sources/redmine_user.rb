# frozen_string_literal: true

module DataSources
  class RedmineUser < DataSource
    def text_method
      :name
    end

    def value_for_preview_method
      :name
    end

    class << self
      def scoped_records(condition)
        return ::Redmine::User.none if condition.blank?

        ::Redmine::User.where(condition)
      end
    end
  end
end
