class CreateMemberGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :member_groups, comment: "组织和成员关系" do |t|
      t.bigint :member_id, comment: "成员ID", null: false
      t.bigint :group_id, comment: "组织ID", null: false
      t.timestamps
    end
    add_index :member_groups, [:group_id, :member_id], unique: true
  end
end
