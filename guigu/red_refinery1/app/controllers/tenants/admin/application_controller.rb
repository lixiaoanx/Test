# frozen_string_literal: true

module Tenants::Admin
  class ApplicationController < Tenants::ApplicationController
    before_action :require_moderator_or_owner!

    protected

      def require_moderator_or_owner!
        unless current_member.moderator?
          forbidden!
        end
      end
  end
end
