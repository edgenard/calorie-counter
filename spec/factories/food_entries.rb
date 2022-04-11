FactoryBot.define do
  factory :food_entry do
    user { association(:user) }
    meal { association(:meal) }
    calories { 1000 }
    name { "Steak" }
    eaten_at { "2022-04-10 21:37:38" }
  end
end
