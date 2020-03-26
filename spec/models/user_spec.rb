require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#next_round" do
    it "returns nil if there are no questions" do
      user = FactoryBot.create(:user)
      expect(user.next_round).to be_nil
    end

    it "returns the next round with unanswered questions" do
      user = FactoryBot.create(:user)
      question = FactoryBot.create(:question)

      expect(user.next_round).to eq(question.round)
    end

    it "doesn't return rounds with all answered questions" do
      user = FactoryBot.create(:user)
      answered_question = FactoryBot.create(:question)
      question = FactoryBot.create(:question)
      FactoryBot.create(:user_answer, :question => answered_question, :user => user)

      expect(user.next_round).to eq(question.round)
    end
  end
end
