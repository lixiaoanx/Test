# frozen_string_literal: true

module Fields
  class AttachmentField < Field
    serialize :validations, Validations::AttachmentField
    serialize :options, NonConfigurable

    include Fields::AttachmentField::Fake
    include Fields::AttachmentField::Postgres

    def stored_type
      :integer
    end

    protected

      def interpret_extra_to(model, accessibility, overrides = {})
        model.has_one_attached name
        if accessibility == :readonly
          model.attr_readonly name
        end
      end
  end
end
