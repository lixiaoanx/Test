class CreateGroupByConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :group_by_conditions do |t|
      t.references :custom_query, foreign_key: true, null: false
      t.references :field, foreign_key: true, null: false

      t.timestamps
    end
  end
end
