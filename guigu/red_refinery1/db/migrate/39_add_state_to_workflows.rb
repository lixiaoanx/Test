class AddStateToWorkflows < ActiveRecord::Migration[6.0]
  def change
    change_table :workflows do |t|
      t.integer :state, default: 0, comment: "0-active,1-draft, 2-inactive"
      t.bigint :origin_workflow_id, comment: "关联原始版本工作流"
    end
  end
end
