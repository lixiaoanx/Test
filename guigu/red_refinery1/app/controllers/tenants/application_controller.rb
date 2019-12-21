# frozen_string_literal: true

module Tenants
  class ApplicationController < ::ApplicationController
    before_action :authenticate_user!
    before_action :set_tenant
    before_action :require_membership!
    before_action :set_page_layout_data, if: -> { request.format.html? }

    def current_member
      @_current_member ||= @tenant.members.find_by(user: current_user)
    end
    helper_method :current_member

    protected

      def set_tenant
        @tenant = Tenant.find_by!(permalink: params[:tenant_id])
      end

      def require_membership!
        unless current_member&.accessible?
          forbidden!
        end
      end

      def set_page_layout_data
        @_sidebar_name = "tenants"
      end
  end
end
