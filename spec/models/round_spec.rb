require 'rails_helper'

RSpec.describe Round, type: :model do
  describe "#next_question" do
    it "returns the next question for a user" do
      user = FactoryBot.create(:user)
      round = FactoryBot.create(:round)
      question = FactoryBot.create(:question, round: round)
      next_question = FactoryBot.create(:question, round: round)
      answer_correct(user, question)

      expect(round.next_question(user)).to eq(next_question)
    end

    it "returns nil if there are no questions left" do
      user = FactoryBot.create(:user)
      round = FactoryBot.create(:round)
      question = FactoryBot.create(:question, round: round)
      answer_correct(user, question)

      expect(round.next_question(user)).to eq(nil)
    end

    it "does not get confused about ids from user_answers" do
      user = FactoryBot.create(:user)
      round = FactoryBot.create(:round)
      question = FactoryBot.create(:question, round: round)
      next_question = FactoryBot.create(:question, round: round)
      2.times { FactoryBot.create(:user_answer) }
      answer_correct(user, question)

      expect(round.next_question(user)).to eq(next_question)
    end
  end
end
