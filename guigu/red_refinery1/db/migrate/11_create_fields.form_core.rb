# This migration comes from form_core
class CreateFields < ActiveRecord::Migration[6.0]
  def change
    create_table :fields do |t|
      t.string :name, null: false
      t.integer :accessibility, null: false
      t.text :validations
      t.text :options
      t.string :type, null: false, index: true
      t.references :form, foreign_key: true

      t.timestamps

      t.index [:form_id, :name], unique: true
    end
  end
end
