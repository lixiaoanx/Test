class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
      t.references :user, foreign_key: true

      t.bigint :redmine_user_id

      t.timestamps
    end
  end
end
