# frozen_string_literal: true

class MetalForm < ApplicationRecord
  include FormCore::Concerns::Models::Form

  self.table_name = "forms"

  belongs_to :tenant
  belongs_to :project

  has_many :entries, foreign_key: "form_id", dependent: :delete_all
  has_many :fields, foreign_key: "form_id", dependent: :destroy

  default_value_for :name,
                    ->(_) { "form_#{SecureRandom.hex(3)}" },
                    allow_nil: false

  validates :name,
            presence: true,
            uniqueness: true

  before_validation do
    self.tenant ||= project&.tenant
  end

  include Forms::Fake
  include Forms::Postgres

  def save_virtual_record!(virtual_record, entry = entries.build)
    transaction do
      entry.tenant = tenant
      entry.project = project
      entry.children.destroy_all if entry.persisted?
      entry.data = {}

      prepare_entry entry, virtual_record

      entry.save!
    end

    entry
  end

  def load_entry_to(virtual_record, entry)
    virtual_record.disable_attr_readonly!
    fields.includes(:nested_form).each do |field|
      field.pg_decode(entry, virtual_record)
    end
    virtual_record.enable_attr_readonly!

    virtual_record
  end

  def load_entry(entry, virtual_model: nil)
    virtual_record = (virtual_model || to_virtual_model).new
    load_entry_to virtual_record, entry

    virtual_record
  end

  def prepare_entry(entry, virtual_record)
    entry.form_id = id
    fields.includes(:nested_form).each do |field|
      field.pg_encode virtual_record, entry
    end
  end
end
