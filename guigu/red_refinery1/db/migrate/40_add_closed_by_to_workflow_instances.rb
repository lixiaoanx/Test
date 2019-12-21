class AddClosedByToWorkflowInstances < ActiveRecord::Migration[6.0]
  def change
    change_table :workflow_instances do |t|
      t.references :closed_by, polymorphic: true
    end
  end
end
