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

  describe "#all_user_stats" do
    it "returns stats for users sorted by percentage" do
      best_user = FactoryBot.create(:user)
      worst_user = FactoryBot.create(:user)
      @questions.each do |question|
        answer_correct(best_user, question)
        answer_incorrect(worst_user, question)
      end
      answer_correct(@user, @questions[0])
      answer_incorrect(@user, @questions[1])

      all_user_stats = StatsService.all_user_stats

      expect(all_user_stats[0].username).to eq(best_user.username)
      expect(all_user_stats[1].username).to eq(@user.username)
      expect(all_user_stats[2].username).to eq(worst_user.username)
      expect(all_user_stats[0].rank).to eq(1)
      expect(all_user_stats[1].rank).to eq(2)
      expect(all_user_stats[2].rank).to eq(3)
    end

    it "breaks ties on average duration" do
      best_user = FactoryBot.create(:user)
      worst_user = FactoryBot.create(:user)
      @questions.each do |question|
        answer_correct(best_user, question, duration: 1.0)
        answer_correct(worst_user, question, duration: 3.0)
      end
      answer_correct(@user, @questions[0], duration: 2.0)
      answer_correct(@user, @questions[1], duration: 2.0)

      all_user_stats = StatsService.all_user_stats

      expect(all_user_stats[0].username).to eq(best_user.username)
      expect(all_user_stats[1].username).to eq(@user.username)
      expect(all_user_stats[2].username).to eq(worst_user.username)
      expect(all_user_stats[0].rank).to eq(1)
      expect(all_user_stats[1].rank).to eq(2)
      expect(all_user_stats[2].rank).to eq(3)
    end

    it "does not include users who have answered no questions" do
      all_user_stats = StatsService.all_user_stats
      expect(all_user_stats.length).to eq(0)
    end
  end
end
