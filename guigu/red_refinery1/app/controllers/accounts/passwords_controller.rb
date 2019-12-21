# frozen_string_literal: true

module Accounts
  class PasswordsController < Accounts::ApplicationController
    before_action :set_user

    # GET /account/password
    def show
      prepare_meta_tags title: t(".title")
    end

    # PUT /account/password/
    def update
      if @user.update_with_password(user_params)
        bypass_sign_in @user, scope: :user
        redirect_to after_update_url, notice: t("accounts.passwords.show.updated")
      else
        @user.clean_up_passwords
        prepare_meta_tags title: t("accounts.passwords.show.title")
        render :show
      end
    end

    private

      def set_user
        # Generate the same SQL with `current_user` that we can benefit caching
        @user = User.order(id: :asc).find(current_user.id)
      end

      def user_params
        params.require(:user).permit(:password, :password_confirmation, :current_password)
      end

      def after_update_url
        account_password_url
      end
  end
end
