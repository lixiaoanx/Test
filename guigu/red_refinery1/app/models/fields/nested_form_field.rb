# frozen_string_literal: true

module Fields
  class NestedFormField < Field
    after_create do
      build_nested_form(tenant: form.tenant).save!
    end

    serialize :validations, Validations::NestedFormField
    serialize :options, NonConfigurable

    include Fields::NestedFormField::Fake
    include Fields::NestedFormField::Postgres

    def attached_nested_form?
      true
    end

    protected

      def interpret_attribute_to(model, accessibility, overrides = {})
        nested_model = nested_form.to_virtual_model(overrides: { _global: { accessibility: accessibility } })
        model.nested_models[name] = nested_model

        model.embeds_one name, anonymous_class: nested_model, validate: true
        model.accepts_nested_attributes_for name, reject_if: :all_blank
      end
  end
end
