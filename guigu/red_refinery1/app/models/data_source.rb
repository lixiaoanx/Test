# frozen_string_literal: true

class DataSource < FieldOptions
  def type_key
    self.class.type_key
  end

  def stored_type
    :integer
  end

  def foreign_field_name_suffix
    "_id"
  end

  def foreign_field_name(field_name)
    "#{field_name}#{foreign_field_name_suffix}"
  end

  def value_method
    :id
  end

  def text_method
    raise NotImplementedError
  end

  def value_for_preview_method
    raise NotImplementedError
  end

  def scoped_condition
    serializable_hash
  end

  def scoped_records(**additional_condition)
    condition = scoped_condition.merge(additional_condition)
    self.class.scoped_records(condition)
  end

  def interpret_to(model, field_name, accessibility, _options = {}); end

  class << self
    def type_key
      model_name.name.split("::").last.underscore
    end

    def scoped_records(_condition)
      raise NotImplementedError
    end
  end
end

require_dependency "data_sources"
