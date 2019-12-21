# frozen_string_literal: true

module Tenants::Admin::Projects
  class MembersController < Tenants::Admin::Projects::ApplicationController
    before_action :set_member, only: %i[edit update destroy]

    def index
      @members = @project.members.page(params[:page]).per(params[:per_page])
    end

    def new
      @member = Member.new
    end

    def edit
    end

    def create
      member_id = member_params[:id]
      @member = @tenant.members.find(member_id)

      @member.member_groups.joins(:group).where(groups: { project_id: @project.id }).delete_all

      groups = @project.groups.where(id: member_params[:group_ids].reject(&:blank?))
      groups.each do |group|
        @member.groups << group
      end

      redirect_to tenant_admin_project_members_url(@tenant, @project), notice: t(".shared.notice.created")
    end

    def update
      @member.member_groups.joins(:group).where(groups: { project_id: @project.id }).delete_all

      groups = @project.groups.where(id: member_params[:group_ids].reject(&:blank?))
      groups.each do |group|
        @member.groups << group
      end

      redirect_to tenant_admin_project_members_url(@tenant, @project), notice: t(".shared.notice.updated")
    end

    def destroy
      @member.member_groups.joins(:group).where(groups: { project_id: @project.id }).delete_all

      redirect_to tenant_admin_project_members_url(@tenant, @project), notice: t(".shared.notice.deleted")
    end

    def sync
      # TODO: Extract to an async job if meet performance problem
      # TODO: Also remove member if not in project anymore?
      @tenant.connect_with_redmine do
        redmine_project = Redmine::Project.find(@project.redmine_project_id)
        redmine_project.members.includes(:user).each do |redmine_member|
          redmine_user = redmine_member.user

          ApplicationRecord.connected_to(role: :writing) do
            unless @tenant.members.where(redmine_user_id: redmine_user.id).exists?
              role = redmine_user.admin ? @tenant.moderator_role : @tenant.member_role
              @tenant.members.create! redmine_user_id: redmine_user.id, role: role
            end

            membership = @tenant.members.find_by(redmine_user_id: redmine_user.id)
            membership ||=
              begin
                role = redmine_user.admin ? @tenant.moderator_role : @tenant.member_role
                @tenant.members.create! user: user, redmine_user_id: redmine_user.id, role: role
              end

            @project.default_group.members << membership
          rescue ActiveRecord::RecordNotUnique
            next
          end
        end
      end

      redirect_to tenant_admin_project_members_url(@tenant, @project), notice: t(".shared.notice.updated")
    end

    private

      def set_member
        @member = @project.members.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def member_params
        params.require(:member).permit(:id, group_ids: [])
      end
  end
end
