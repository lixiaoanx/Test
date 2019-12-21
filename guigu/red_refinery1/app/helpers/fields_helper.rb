# frozen_string_literal: true

module FieldsHelper
  def options_for_field_types(form, selected: nil)
    fields = Field.descendants
    if form.attachable_id.present?
      fields -= [Fields::NestedFormField, Fields::MultipleNestedFormField]
    end

    options_for_select(fields.map { |klass| [klass.model_name.human, klass.to_s] }, selected)
  end

  def options_for_data_source_types(selected: nil)
    options_for_select(DataSource.descendants.map { |klass| [klass.model_name.human, klass.to_s] }, selected)
  end

  def field_label(form, field_name:)
    field_name = field_name.to_s.split(".").first.to_sym

    form.fields.select do |field|
      field.name == field_name
    end.first&.label
  end
end
