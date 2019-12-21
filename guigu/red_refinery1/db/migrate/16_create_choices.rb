class CreateChoices < ActiveRecord::Migration[6.0]
  def change
    create_table :choices do |t|
      t.references :field, foreign_key: true

      t.text :label, null: false

      t.timestamps
    end
  end
end
