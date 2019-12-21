class AddCategoryIdToWorkflows < ActiveRecord::Migration[6.0]
  def change
    change_table :workflows do |t|
      t.references :category, foreign_key: { to_table: "workflow_categories" }
    end
  end
end
