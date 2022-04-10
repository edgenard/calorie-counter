FactoryBot.define do
  factory :meal_setting do
    meal { association(:meal) }
    user { association(:user) }
    max_entries_per_day { 5 }
  end
end
