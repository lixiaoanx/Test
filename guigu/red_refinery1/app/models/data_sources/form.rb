# frozen_string_literal: true

module DataSources
  class Form < DataSource
    def text_method
      display_field_name.to_sym
    end

    def value_for_preview_method
      display_field_name.to_sym
    end

    attribute :form_id, :integer
    attribute :display_field_name, :string

    validates :form_id, :display_field_name,
              presence: true

    def scoped_condition
      { id: form_id }
    end

    class << self
      def scoped_records(condition)
        return ::Form.none if condition.blank?

        ::Form.where(condition).first&.pg_ar_class&.all
      end
    end
  end
end
