FactoryBot.define do
  factory :round do
    label { "MyText" }
    association :game
  end
end
