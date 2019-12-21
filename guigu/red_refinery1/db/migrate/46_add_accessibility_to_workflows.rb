class AddAccessibilityToWorkflows < ActiveRecord::Migration[6.0]
  def change
    change_table :workflows do |t|
      t.integer :accessibility, null: false, default: 0
    end
  end
end
