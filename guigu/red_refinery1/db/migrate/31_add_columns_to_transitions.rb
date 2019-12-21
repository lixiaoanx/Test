class AddColumnsToTransitions < ActiveRecord::Migration[6.0]
  def change
    change_table :workflow_transitions do |t|
      t.string :uid
      t.string :title
      t.text :options
    end
  end
end
