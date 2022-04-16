class AddEatenAtDateEatenAtTimeToFoodEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :food_entries, :eaten_at_date, :date
    add_column :food_entries, :eaten_at_time, :time
  end
end
