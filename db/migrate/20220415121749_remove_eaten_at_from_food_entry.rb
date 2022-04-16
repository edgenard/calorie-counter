class RemoveEatenAtFromFoodEntry < ActiveRecord::Migration[7.0]
  def change
    remove_column :food_entries, :eaten_at
  end
end
