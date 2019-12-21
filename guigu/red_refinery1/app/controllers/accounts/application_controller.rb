# frozen_string_literal: true

module Accounts
  class ApplicationController < ::ApplicationController
    before_action :authenticate_user!
    before_action :set_page_layout_data, if: -> { request.format.html? }

    protected

      def set_page_layout_data
        @_sidebar_name = "accounts"
      end
  end
end
