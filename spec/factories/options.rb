FactoryBot.define do
  factory :option do
    prompt { "MyText" }
    correct { false }
    question_id { 1 }
  end
end
