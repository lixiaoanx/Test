# frozen_string_literal: true

class Admin::TenantsController < Admin::ApplicationController
  before_action :set_tenant, only: [:show, :edit, :update, :destroy]

  # GET /tenants
  def index
    prepare_meta_tags title: t(".title")

    @tenants = Tenant.all.page(params[:page]).per(params[:per_page])
  end

  # GET /tenants/1
  def show
    prepare_meta_tags title: @tenant.name

    @valid_host =
      begin
        @tenant.redmine_api_client.ping
      rescue
        false
      end

    @valid_database_url =
      begin
        @tenant.connect_with_redmine do
          Redmine::User.first # No error raised means connection is OK
          true
        end
      rescue
        false
      end
  end

  # GET /tenants/new
  def new
    prepare_meta_tags title: t(".title")

    @tenant = Tenant.new
  end

  # GET /tenants/1/edit
  def edit
    prepare_meta_tags title: t(".title")
  end

  # POST /tenants
  def create
    @tenant = Tenant.new(tenant_params)
    @tenant.creator = current_user

    if @tenant.save
      redirect_to admin_tenant_url(@tenant), notice: t(".shared.notice.created")
    else
      prepare_meta_tags title: t("admin.tenants.new.title")
      render :new
    end
  end

  # PATCH/PUT /tenants/1
  def update
    if @tenant.update(tenant_params)
      redirect_to admin_tenant_url(@tenant), notice: t(".shared.notice.updated")
    else
      prepare_meta_tags title: t("admin.tenants.edit.title")
      render :edit
    end
  end

  # DELETE /tenants/1
  def destroy
    @tenant.destroy
    redirect_to admin_tenants_url, notice: t(".shared.notice.deleted")
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_tenant
      @tenant = Tenant.find_by!(permalink: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tenant_params
      params.require(:tenant).permit(:permalink, :name, :redmine_host, :redmine_secret, :redmine_database_url)
    end
end
