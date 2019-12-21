class AddParentToEntries < ActiveRecord::Migration[6.0]
  def change
    change_table :entries do |t|
      t.references :parent, foreign_key: { to_table: :entries }
    end
  end
end
