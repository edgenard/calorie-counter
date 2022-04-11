class CreateFoodEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :food_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :meal, null: false, foreign_key: true
      t.integer :calories, null: false
      t.string :name, null: false
      t.datetime :eaten_at, null: false

      t.timestamps
    end
  end
end
