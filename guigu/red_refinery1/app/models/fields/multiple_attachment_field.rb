# frozen_string_literal: true

module Fields
  class MultipleAttachmentField < Field
    serialize :validations, Validations::MultipleAttachmentField
    serialize :options, NonConfigurable

    include Fields::MultipleAttachmentField::Fake
    include Fields::MultipleAttachmentField::Postgres

    def stored_type
      :integer
    end

    def array?
      true
    end

    protected

      def interpret_extra_to(model, accessibility, overrides = {})
        model.has_many_attached name
        if accessibility == :readonly
          model.attr_readonly name
        end
      end
  end
end
