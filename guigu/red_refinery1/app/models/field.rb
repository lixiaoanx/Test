# frozen_string_literal: true

class Field < ApplicationRecord
  include FormCore::Concerns::Models::Field

  self.table_name = "fields"

  belongs_to :form, class_name: "MetalForm", foreign_key: "form_id", touch: true

  # Only use for specific fields
  has_many :choices, -> { order(position: :asc) }, dependent: :destroy, autosave: true
  has_one :nested_form, as: :attachable, dependent: :destroy

  acts_as_list scope: [:form_id]

  validates :label,
            presence: true
  validates :type,
            inclusion: {
              in: ->(_) { Field.descendants.map(&:to_s) }
            },
            allow_blank: false

  default_value_for :name,
                    ->(_) { "field_#{SecureRandom.hex(3)}" },
                    allow_nil: false

  def builtin?
    false
  end

  def self.type_key
    model_name.name.demodulize.underscore.to_sym
  end

  def type_key
    self.class.type_key
  end

  def array?
    false
  end

  def can_act_as_evaluatable?
    false
  end

  def act_as_evaluatable?
    can_act_as_evaluatable? && script.present?
  end

  include Fields::Postgres
  include Fields::Fake
  include Fields::Helper
  include Fields::CustomQuery

  def interpret_to(model, overrides: {})
    check_model_validity!(model)

    accessibility = overrides.fetch(:accessibility, self.accessibility)
    return model if accessibility == :hidden

    interpret_attribute_to model, accessibility, overrides
    interpret_validations_to model, accessibility, overrides
    interpret_options_to model, accessibility, overrides
    interpret_extra_to model, accessibility, overrides

    if act_as_evaluatable?
      model.lazy_evaluate(name, script)
    end

    model
  end

  protected

    def interpret_attribute_to(model, accessibility, overrides = {})
      default_value = overrides.fetch(:default_value, self.default_value)
      if array?
        model.attribute name, stored_type, default: (default_value || []), array_without_blank: true
      else
        model.attribute name, stored_type, default: default_value
      end

      if accessibility == :readonly
        model.attr_readonly name
      end
    end

    def interpret_validations_to(model, accessibility, overrides = {})
      return unless accessibility == :read_and_write

      validations_overrides = overrides.fetch(:validations) { {} }
      validations =
        if validations_overrides.any?
          self.validations.dup.update(validations_overrides)
        else
          self.validations
        end

      validations.interpret_to(model, name, accessibility)
    end

    def interpret_options_to(model, accessibility, overrides = {})
      options_overrides = overrides.fetch(:options) { {} }
      options =
        if options_overrides.any?
          self.options.dup.update(options_overrides)
        else
          self.options
        end

      options.interpret_to(model, name, accessibility)
    end

    def interpret_extra_to(model, accessibility, overrides = {}); end
end

require_dependency "fields"
