class AddPositionToChoices < ActiveRecord::Migration[6.0]
  def change
    change_table :choices do |t|
      t.integer :position
    end
  end
end
