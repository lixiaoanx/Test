class CreateTenants < ActiveRecord::Migration[6.0]
  def change
    create_table :tenants do |t|
      t.references :creator, foreign_key: { to_table: "users" }

      t.string :permalink, null: false, index: { unique: true }
      t.string :name, null: false

      t.string :redmine_host
      t.string :redmine_secret
      t.string :redmine_database_url

      t.timestamps
    end
  end
end
