# This migration comes from form_core
class CreateForms < ActiveRecord::Migration[6.0]
  def change
    create_table :forms do |t|
      t.references :tenant, null: false, foreign_key: true

      t.string :name, null: false, index: { unique: true }
      t.string :type, null: false, index: true

      t.timestamps
    end
  end
end
