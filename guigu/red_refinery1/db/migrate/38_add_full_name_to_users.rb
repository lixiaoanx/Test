class AddFullNameToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.string :full_name
    end
  end
end
