FactoryBot.define do
  factory :question do
    prompt { "A flashing red traffic light signifies that a driver should do what?" }
    association :round
    options do
      [
        FactoryBot.build(:option, :correct => true),
        FactoryBot.build(:option, :correct => false),
      ]
    end
  end
end
