# frozen_string_literal: true

module Forms
  module Fake
    extend ActiveSupport::Concern

    def build_random_record
      record = to_virtual_model.new
      set_random_value_to(record)
    end

    def set_random_value_to(record)
      fields.each do |field|
        field.generate_fake_value_to(record)
      rescue NotImplementedError
        next
      end
      record
    end

    def create_random_record!
      record = build_random_record
      save_virtual_record!(record)
      record
    end

    def batch_create_random_record!(batch_size = 10, disable_logger: false)
      model = to_virtual_model(overrides: { _global: { accessibility: :readonly } })

      if disable_logger
        old_logger = ActiveRecord::Base.logger
        ActiveRecord::Base.logger = nil
      end
      batch_size.times do
        record = model.new
        record.disable_attr_readonly!
        set_random_value_to(record)

        save_virtual_record!(record)
      end
      if disable_logger
        ActiveRecord::Base.logger = old_logger
      end

      batch_size
    end

    def build_random_fields(type_key_seq:)
      transaction(requires_new: true) do
        type_key_seq.each do |type_key|
          if type_key.is_a? Hash
            type_key.each do |k, v|
              klass = ::Fields::MAP[k]
              unless k.attached_nested_form?
                raise ArgumentError, "Only nested form types can be key"
              end
              field = fields.build type: ::Fields::MAP[type_key].to_s,
                                   accessibility: "read_and_write"
              field.label = "#{klass.model_name.name.demodulize.titleize} #{field.name.to_s.split("_").last}"
              field.save!
              klass.configure_fake_options_to field
              field.save!
              field.nested_form.build_random_fields(v)
              field.save!
            end
          else
            klass = ::Fields::MAP[type_key]
            unless klass
              raise ArgumentError, "Can't reflect field class by #{type_key}"
            end
            field = fields.build type: ::Fields::MAP[type_key].to_s,
                                 accessibility: "read_and_write"
            field.label = "#{klass.model_name.name.demodulize.titleize} #{field.name.to_s.split("_").last}"
            field.save!
            klass.configure_fake_options_to field
            field.save!
          end
        end
      end
    end

    module ClassMethods
      DEFAULT_TYPE_KEY_SEQ =
        ::Field.descendants.map(&:type_key) -
          %i[nested_form_field multiple_nested_form_field] -
          %i[attachment_field multiple_attachment_field] -
          %i[resource_select_field multiple_resource_select_field] -
          %i[resource_field multiple_resource_field]
      def create_random_form!(tenant:, project:, type_key_seq: DEFAULT_TYPE_KEY_SEQ)
        form = tenant.forms.create! project: project, title: "Random form #{SecureRandom.hex(3)}"
        form.build_random_fields type_key_seq: type_key_seq
        form
      end
    end
  end
end
