FactoryBot.define do
  factory :user do
    email { generate(:email) }
    password { "super secret password" }
  end
end
