class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.references :tenant, null: false, foreign_key: true
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
