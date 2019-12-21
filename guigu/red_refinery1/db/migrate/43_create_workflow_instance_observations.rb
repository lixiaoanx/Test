class CreateWorkflowInstanceObservations < ActiveRecord::Migration[6.0]
  def change
    create_table :workflow_instance_observations do |t|
      t.references :instance, null: false, foreign_key: { to_table: "workflow_instances" }
      t.references :observable, polymorphic: true, null: false, index: { name: "idx_observable_type_and_observable_id" }
      t.references :granted_by, polymorphic: true, index: false

      t.boolean :read, null: false, default: false
      t.text :options

      t.timestamps
    end
  end
end
