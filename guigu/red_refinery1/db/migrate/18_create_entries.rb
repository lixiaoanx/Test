class CreateEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :entries do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :project, index: true

      t.references :form, foreign_key: true
      t.jsonb :data, null: false, default: {}

      t.timestamps
    end
  end
end
