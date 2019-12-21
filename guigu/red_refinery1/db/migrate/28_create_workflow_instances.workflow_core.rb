# This migration comes from workflow_core (originally 20180912223642)
class CreateWorkflowInstances < ActiveRecord::Migration[6.0]
  def change
    create_table :workflow_instances do |t|
      t.references :tenant, null: false, foreign_key: true

      t.text :payload
      t.integer :status, null: false, default: 0

      t.references :workflow, foreign_key: true
      t.timestamps
    end
  end
end
