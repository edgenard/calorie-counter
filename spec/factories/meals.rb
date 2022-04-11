FactoryBot.define do
  factory :meal do
    user { association(:user) }
    name { "Dinner" }
    max_entries_per_day { 5 }
  end
end
