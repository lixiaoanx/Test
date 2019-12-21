class AddColumnsToWorkflows < ActiveRecord::Migration[6.0]
  def change
    change_table :workflows do |t|
      t.string :title
      t.text :description

      t.references :form, null: false, index: true
      t.references :project, index: true
    end
  end
end
