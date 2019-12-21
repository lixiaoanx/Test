# frozen_string_literal: true

module Fields
  module Helper
    extend ActiveSupport::Concern

    def options_configurable?
      options.attributes.any? || options.class.reflections.any?
    end

    def validations_configurable?
      validations.attributes.any? || validations.class.reflections.any?
    end

    def attached_choices?
      false
    end

    def attached_data_source?
      false
    end

    def attached_nested_form?
      false
    end
  end
end
