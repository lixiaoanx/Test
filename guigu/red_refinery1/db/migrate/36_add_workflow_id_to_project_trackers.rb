class AddWorkflowIdToProjectTrackers < ActiveRecord::Migration[6.0]
  def change
    change_table :project_trackers do |t|
      t.references :workflow, null: false, foreign_key: true
    end
  end
end
