class Setting < ApplicationRecord
  DEFAULT_MAX_CALORIES = 2100
  belongs_to :user
end
