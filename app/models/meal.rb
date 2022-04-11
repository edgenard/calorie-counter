class Meal < ApplicationRecord
  DEFAULT_MAX_ENTRIES = 5
  DINNER = "Dinner".freeze
  LUNCH = "Lunch".freeze
  BREAKFAST = "Breakfast".freeze
  belongs_to :user
end
