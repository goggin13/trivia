FactoryBot.define do
  factory :user_answer do
    association :user
    association :option
    association :question
    duration { 2.5 }
  end
end
