class CreateProjectTrackers < ActiveRecord::Migration[6.0]
  def change
    create_table :project_trackers do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.bigint :redmine_tracker_id

      t.timestamps
    end
  end
end
