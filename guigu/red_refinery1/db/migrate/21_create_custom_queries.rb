class CreateCustomQueries < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_queries do |t|
      t.references :tenant, null: false, foreign_key: true

      t.references :form, foreign_key: true, null: false

      t.string :title

      t.timestamps
    end
  end
end
