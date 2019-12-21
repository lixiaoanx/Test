# frozen_string_literal: true

class Tenant
  module RedmineConnectable
    extend ActiveSupport::Concern

    included do
      after_save :refresh_redmine_connections
      after_destroy :refresh_redmine_connections
    end

    def redmine_api_client
      @redmine_api_client ||= RedmineApi.new(redmine_host, redmine_secret)
    end

    def connect_with_redmine
      return unless block_given?

      RedmineRecord.connected_to(role: :"tenant_#{id}") do
        yield
      end
    end

    def refresh_redmine_connections
      RedmineRecord.refresh_redmine_connections!
    end
  end
end
