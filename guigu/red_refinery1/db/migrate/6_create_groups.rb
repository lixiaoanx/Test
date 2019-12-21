class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    enable_extension "btree_gin"

    create_table :groups, comment: "成员组织" do |t|
      t.bigint :tenant_id, index: true, null: false, comment: "租户ID"
      t.bigint :project_id, index: true, null: false, comment: "项目ID"
      t.string :name, comment: "组织名称", null: false
      t.bigint :parent_id, comment: "父级组织ID"
      t.integer :children_count, default: 0, comment: "下级组织数量；标记是否末级组织；children count为0就是末级组织"
      t.bigint :path, array: true, default: [], comment: "上级路径"
      t.integer :depth, default: 1, comment: "深度；root的深度为1"
      t.integer :members_count, default: 0, comment: "拥有成员数量"
      t.timestamps
    end

    add_index :groups, :path, using: :gin
    add_index :groups, [:project_id, :path], using: :gin
  end
end
