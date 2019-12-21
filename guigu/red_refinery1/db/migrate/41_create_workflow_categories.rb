class CreateWorkflowCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :workflow_categories do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :project, index: true

      t.string :title

      t.timestamps
    end
  end
end
