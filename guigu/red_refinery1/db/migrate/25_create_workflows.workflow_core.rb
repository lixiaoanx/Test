# This migration comes from workflow_core (originally 20180910195950)
class CreateWorkflows < ActiveRecord::Migration[6.0]
  def change
    create_table :workflows do |t|
      t.references :tenant, null: false, foreign_key: true

      t.string :type, null: false
      t.timestamps
    end
  end
end
