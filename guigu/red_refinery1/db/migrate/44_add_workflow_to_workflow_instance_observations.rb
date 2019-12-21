class AddWorkflowToWorkflowInstanceObservations < ActiveRecord::Migration[6.0]
  def change
    change_table :workflow_instance_observations do |t|
      t.references :workflow, foreign_key: true, null: false
    end
  end
end
