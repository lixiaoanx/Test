class AddColumnsToPlaces < ActiveRecord::Migration[6.0]
  def change
    change_table :workflow_places do |t|
      t.string :title
      t.string :uid
    end
  end
end
