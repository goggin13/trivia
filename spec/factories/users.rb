FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "person-#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
