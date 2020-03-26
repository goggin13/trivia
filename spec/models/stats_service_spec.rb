require 'rails_helper'

RSpec.describe StatsService, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @round = FactoryBot.create(:round)
    @questions = (0..1).map do
      FactoryBot.create(:question, :round => @round)
    end
  end

  describe "#user_stats" do
    it "returns stats for a user" do
      answer_correct(@user, @questions[0])
      answer_incorrect(@user, @questions[1])

      user_stats = StatsService.user_stats(@user)

      expect(user_stats.correct).to eq(1)
      expect(user_stats.completed).to eq(2)
      expect(user_stats.percentage).to eq(50.0)
      expect(user_stats.remaining).to eq(0)
    end

    it "returns stats for a user who has no right answers" do
      FactoryBot.create(
        :user_answer,
        :user => @user,
        :option => @questions[0].options.incorrect.first,
        :question => @questions[0]
      )
      FactoryBot.create(
        :user_answer,
        :user => @user,
        :option => @questions[1].options.incorrect.first,
        :question => @questions[1]
      )

      user_stats = StatsService.user_stats(@user)

      expect(user_stats.correct).to eq(0)
      expect(user_stats.completed).to eq(2)
      expect(user_stats.percentage).to eq(0)
    end

    it "returns an empty result object if there are no stats" do
      user_stats = StatsService.user_stats(@user)

      expect(user_stats.correct).to eq(0)
      expect(user_stats.completed).to eq(0)
      expect(user_stats.percentage).to eq(0)
      expect(user_stats.duration).to eq(0)
    end

    it "returns average duration" do
      FactoryBot.create(
        :user_answer,
        :user => @user,
        :question => @questions[0],
        :duration => 1
      )
      FactoryBot.create(
        :user_answer,
        :user => @user,
        :question => @questions[1],
        :duration => 3
      )

      user_stats = StatsService.user_stats(@user)

      expect(user_stats.duration).to eq(2)
    end
  end

  describe "#user_stats" do
    it "returns stats for a user limited to one round" do
      round_two = FactoryBot.create(:round)
      (0..1).map do
        q = FactoryBot.create(:question, :round => round_two)
        answer_correct(@user, q)
      end
      answer_correct(@user, @questions[0])
      user_stats = StatsService.user_round_stats(@user, round_two)

      expect(user_stats.completed).to eq(2)
      expect(user_stats.correct).to eq(2)
      expect(user_stats.percentage).to eq(100.0)
    end

    it "returns number of questions remaining in round" do
      answer_correct(@user, @questions[0])
      user_stats = StatsService.user_round_stats(@user, @round)

      expect(user_stats.completed).to eq(1)
      expect(user_stats.correct).to eq(1)
      expect(user_stats.percentage).to eq(100.0)
      expect(user_stats.remaining).to eq(1)
    end
  end
end
