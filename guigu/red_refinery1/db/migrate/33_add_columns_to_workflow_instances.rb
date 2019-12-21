class AddColumnsToWorkflowInstances < ActiveRecord::Migration[6.0]
  def change
    change_table :workflow_instances do |t|
      t.references :creator, foreign_key: { to_table: "members" }
      t.references :project, index: true

      t.string :type
    end
  end
end
