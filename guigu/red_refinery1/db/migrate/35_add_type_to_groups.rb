class AddTypeToGroups < ActiveRecord::Migration[6.0]
  def change
    change_table :groups do |t|
      t.string :type, null: false
    end
  end
end
