class CreateMealSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :meal_settings do |t|
      t.references :meal, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :max_entries_per_day

      t.timestamps
    end
  end
end
