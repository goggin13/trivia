require 'rails_helper'

RSpec.describe "Home Page", type: :feature do
  describe "home" do
    before do
      @user = FactoryBot.create(:user)
      @round = FactoryBot.create(:round, :label => "Test Round")
    end

    it "says no questions left if there are none" do
      sign_in(@user)
      expect(page).to have_content("You have completed all of the rounds")
    end

    it "shows a link to start playing" do
      question = FactoryBot.create(:question, :round => @round)
      sign_in(@user)

      expect(page).to have_link("Play Test Round", :href => question_path(question))
    end

    it "lists users and their emails and stats" do
      questions = (0..1).map do
        FactoryBot.create(:question, :round => @round)
      end
      FactoryBot.create(
        :user_answer,
        :user => @user,
        :option => questions[0].options.incorrect.first,
        :question => questions[0],
        :duration => 1,
      )
      FactoryBot.create(
        :user_answer,
        :user => @user,
        :option => questions[1].options.correct.first,
        :question => questions[1],
        :duration => 4
      )
      sign_in(@user)

      expect(page).to have_content(@user.email)
      expect(page).to have_content("50.0%")
      expect(page).to have_content("2.5s")
    end
  end
end
