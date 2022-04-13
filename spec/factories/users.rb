FactoryBot.define do
  factory :user do
    email { generate(:email) }
    password { "super secret password" }

    trait :with_meals do
      after(:create) do |user|
        create(:meal, user: user, name: Meal::BREAKFAST)
        create(:meal, user: user, name: Meal::DINNER)
        create(:meal, user: user, name: Meal::LUNCH)
      end
    end
  end
end
