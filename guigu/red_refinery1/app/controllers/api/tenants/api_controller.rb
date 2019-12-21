# frozen_string_literal: true

module Api::Tenants
  class ApiController < ::Api::ApiController
    before_action :set_tenant

    protected

      def set_tenant
        @tenant = Tenant.find_by!(permalink: params[:tenant_id])
      end
  end
end
