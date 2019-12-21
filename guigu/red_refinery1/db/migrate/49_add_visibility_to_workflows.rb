class AddVisibilityToWorkflows < ActiveRecord::Migration[6.0]
  def change
    change_table :workflows do |t|
      t.integer :visibility, null: false, default: 0
    end
  end
end
