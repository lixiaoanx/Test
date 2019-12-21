class AddScriptToFields < ActiveRecord::Migration[6.0]
  def change
    change_table :fields do |t|
      t.text :script
    end
  end
end
