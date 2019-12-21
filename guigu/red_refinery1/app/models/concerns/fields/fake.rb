# frozen_string_literal: true

module Fields
  module Fake
    extend ActiveSupport::Concern

    def generate_fake_value_to(_record)
      raise NotImplementedError
    end

    module ClassMethods
      def configure_fake_options_to(_field); end
    end
  end
end
