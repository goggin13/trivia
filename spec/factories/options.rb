FactoryBot.define do
  factory :option do
    association :question
    prompt { "MyText" }
    correct { false }
  end
end
