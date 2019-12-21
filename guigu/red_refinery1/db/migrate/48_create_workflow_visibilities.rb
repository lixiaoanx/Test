class CreateWorkflowVisibilities < ActiveRecord::Migration[6.0]
  def change
    create_table :workflow_visibilities do |t|
      t.references :workflow, null: false, foreign_key: true
      t.references :target, polymorphic: true, null: false

      t.timestamps
    end
  end
end
