# frozen_string_literal: true

module Accounts
  class MembershipsController < Accounts::ApplicationController
    # GET /account/memberships
    def index
      prepare_meta_tags title: t(".title")

      @tenants = Tenant.all
      @memberships = current_user.members.includes(:role)
    end

    REDMINE_CONNECT_PATH = "red_refinery/connect"

    def update
      @tenant = Tenant.find(params[:id])

      connect_url = URI.parse("#{@tenant.redmine_host}/#{REDMINE_CONNECT_PATH}")

      signer = ParameterSigner.new(secret: @tenant.redmine_secret)
      connect_url.query = signer.signed_params(user_id: current_user.id, tenant_name: @tenant.name).to_query

      redirect_to connect_url.to_s
    end
  end
end
