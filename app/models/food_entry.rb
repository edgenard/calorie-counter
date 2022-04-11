class FoodEntry < ApplicationRecord
  belongs_to :user
  belongs_to :meal
  validates_presence_of :name, :eaten_at, :calories
  validates_numericality_of :calories, greater_than_or_equal_to: 0
  scope :meal_entries_for_day, ->(meal, time) { where(meal: meal, eaten_at: time.beginning_of_day..time.end_of_day) }
end
