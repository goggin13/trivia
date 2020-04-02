require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @game = FactoryBot.create(:game)
    @round = FactoryBot.create(:round, game: @game)
  end

  describe "#next_round" do
    it "returns nil if there are no questions" do
      user = FactoryBot.create(:user)
      expect(user.next_round(@game)).to be_nil
    end

    it "returns the next round with unanswered questions" do
      user = FactoryBot.create(:user)
      question = FactoryBot.create(:question, round: @round)

      expect(user.next_round(@game)).to eq(@round)
    end

    it "doesn't return rounds with all answered questions" do
      answered_question = FactoryBot.create(:question, round: @round)
      user = FactoryBot.create(:user)
      answer(user, answered_question)

      next_round = FactoryBot.create(:round, game: @game)
      question = FactoryBot.create(:question, round: next_round)

      expect(user.next_round(@game)).to eq(next_round)
    end
  end
end
