class AddCommentToWorkflowInstanceObservations < ActiveRecord::Migration[6.0]
  def change
    change_table :workflow_instance_observations do |t|
      t.text :comment
    end
  end
end
