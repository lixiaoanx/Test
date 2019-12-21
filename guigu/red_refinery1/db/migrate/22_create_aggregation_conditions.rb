class CreateAggregationConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :aggregation_conditions do |t|
      t.references :custom_query, foreign_key: true, null: false
      t.references :field, foreign_key: true, null: false

      t.string :aggregation

      t.timestamps
    end
  end
end
