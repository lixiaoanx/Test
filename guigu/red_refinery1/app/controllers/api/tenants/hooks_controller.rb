# frozen_string_literal: true

module Api::Tenants
  class HooksController < ::Api::Tenants::ApiController
    before_action :verify_signature

    def user_connect
      redmine_user = @tenant.connect_with_redmine { Redmine::User.find_by(id: params[:redmine_user_id]) }
      raise Api::ResourceNotFound.new("redmine_user_id") unless redmine_user

      user = ::User.find_by(id: params[:user_id])
      raise Api::ResourceNotFound.new("user_id") unless user

      membership = @tenant.members.find_by(redmine_user_id: redmine_user.id)
      if membership
        if membership.user == user
          render_ok
          return
        elsif membership.user
          raise Api::OperationFailure.new(user_id: "already_bind")
        else
          membership.update! user: user

          render_ok
          return
        end
      end

      role = redmine_user.admin ? @tenant.moderator_role : @tenant.member_role
      membership = @tenant.members.build user: user, redmine_user_id: redmine_user.id, role: role
      unless membership.save
        raise Api::EntityInvalid.new(membership.errors)
      end

      redmine_project_ids = @tenant.connect_with_redmine { redmine_user.projects.pluck(:id) }
      projects = @tenant.projects.where(redmine_project_id: redmine_project_ids).includes(:default_group)
      projects.each do |project|
        membership.groups << project.default_group
      end

      render_ok
    end

    def issue_created
      redmine_issue = @tenant.connect_with_redmine { Redmine::Issue.find_by id: params[:redmine_issue_id] }
      unless redmine_issue
        head :no_content
        return
      end

      tracker = @tenant.trackers.find_by redmine_tracker_id: redmine_issue.tracker_id
      unless tracker
        head :no_content
        return
      end

      workflow = tracker.workflow
      unless workflow
        raise "Workflow##{tracker.workflow_id} not found"
      end

      member = @tenant.members.find_by redmine_user_id: redmine_issue.author_id
      unless member
        # TODO: Create a unbind user member
      end

      _instance = workflow.instances.create! type: "WorkflowInstance",
                                             project: tracker.project,
                                             tenant: tracker.tenant,
                                             creator: member,
                                             redmine_issue_id: redmine_issue.id

      render_ok
    end

    private

      def parameter_signer
        @_parameter_signer ||= ParameterSigner.new(secret: @tenant.redmine_secret)
      end

      def verify_signature
        unless request.method_symbol == :post
          raise "Request method must be `POST`"
        end

        unless parameter_signer.valid?(request.request_parameters[:hook])
          raise Api::SignatureInvalid
        end
      end
  end
end
