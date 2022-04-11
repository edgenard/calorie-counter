FactoryBot.define do
  factory :setting do
    user { association(:user) }
    max_calories_per_day { Setting::DEFAULT_MAX_CALORIES }
  end
end
