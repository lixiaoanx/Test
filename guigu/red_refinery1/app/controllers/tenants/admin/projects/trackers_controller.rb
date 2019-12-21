# frozen_string_literal: true

module Tenants::Admin::Projects
  class TrackersController < Tenants::Admin::Projects::ApplicationController
    before_action :set_tracker, only: %i[edit update destroy]

    def index
      @trackers = @project.trackers.all
    end

    def new
      @tracker = @project.trackers.build
    end

    def edit
    end

    def create
      @tracker = @project.trackers.build(tracker_params)
      @tracker.tenant = @tenant

      if @tracker.save
        redirect_to tenant_admin_project_trackers_url(@tenant, @project), notice: t(".shared.notice.created")
      else
        render :new
      end
    end

    def update
      if @tracker.update(tracker_params)
        redirect_to tenant_admin_project_trackers_url(@tenant, @project), notice: t(".shared.notice.updated")
      else
        render :edit
      end
    end

    def destroy
      @tracker.destroy

      redirect_to tenant_admin_project_trackers_url(@tenant, @project), notice: t(".shared.notice.deleted")
    end

    private

      def set_tracker
        @tracker = @project.trackers.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def tracker_params
        params.require(:tracker).permit(:redmine_tracker_id, :workflow_id)
      end
  end
end
