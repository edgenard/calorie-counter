class Meal < ApplicationRecord
  DEFAULT_MAX_ENTRIES = 5
  DINNER = "Dinner".freeze
  LUNCH = "Lunch".freeze
  BREAKFAST = "Breakfast".freeze
  belongs_to :user
  validates_presence_of :name, :max_entries_per_day
  validates_numericality_of :max_entries_per_day, greater_than_or_equal_to: 0
end
