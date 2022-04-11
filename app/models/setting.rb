class Setting < ApplicationRecord
  DEFAULT_MAX_CALORIES = 2100
  belongs_to :user
  validates_numericality_of :max_calories_per_day, greater_than_or_equal_to: 1
end
