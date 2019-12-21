class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.references :tenant, null: false, foreign_key: true
      t.bigint :redmine_project_id

      t.string :name, null: false

      t.timestamps
    end
  end
end
