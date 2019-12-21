class AddColumnsToWorkflowTokens < ActiveRecord::Migration[6.0]
  def change
    change_table :workflow_tokens do |t|
      t.string :type

      t.references :project, index: true
      t.references :tenant, null: false, foreign_key: true
      t.boolean :hidden, default: false
      t.text :payload

      t.references :assignable, polymorphic: true, index: true
      t.references :forwardable, polymorphic: true, index: true
      t.references :processable, polymorphic: true, index: true
    end
  end
end
