# frozen_string_literal: true

module Tenants::Admin::Projects
  class GroupsController < Tenants::Admin::Projects::ApplicationController
    before_action :set_group, only: %i[edit update destroy]
    before_action :forbid_builtin!, only: %i[edit update destroy]

    def index
      @groups = @project.groups.order("array_append(path, id) asc").all
    end

    def new
      @group = Group.new
    end

    def edit
    end

    def create
      @group = @project.custom_groups.build(group_params)
      @group.tenant = @tenant

      if @group.save
        redirect_to tenant_admin_project_groups_url(@tenant, @project), notice: t(".shared.notice.created")
      else
        render :new
      end
    end

    def update
      if @group.update(group_params)
        redirect_to tenant_admin_project_groups_url(@tenant, @project), notice: t(".shared.notice.updated")
      else
        render :edit
      end
    end

    def destroy
      @group.destroy

      redirect_to tenant_admin_project_groups_url(@tenant, @project), notice: t(".shared.notice.deleted")
    end

    private

      def set_group
        @group = @project.custom_groups.find(params[:id])
      end

      def forbid_builtin!
        if @group.builtin?
          redirect_to tenant_admin_project_groups_url(@tenant, @project)
        end
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def group_params
        params.require(:group).permit(:parent_id, :name)
      end
  end
end
