# frozen_string_literal: true

module Accounts
  class ProfilesController < Accounts::ApplicationController
    before_action :set_user

    # GET /account/profile
    def show
      prepare_meta_tags title: t(".title")
    end

    # PUT /account/profile
    def update
      if @user.update_without_password(user_params)
        redirect_to after_update_url, notice: t("accounts.profiles.show.updated")
      else
        prepare_meta_tags title: t("accounts.profiles.show.title")
        render :show
      end
    end

    private

      def set_user
        # Generate the same SQL with `current_user` that we can benefit caching
        @user = User.order(id: :asc).find(current_user.id)
      end

      def user_params
        params.require(:user).permit(:email, :full_name)
      end

      def after_update_url
        account_profile_url
      end
  end
end
