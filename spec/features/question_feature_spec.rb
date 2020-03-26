require 'rails_helper'

RSpec.describe "Questions", type: :feature do
  describe "show" do
    before do
      @user = FactoryBot.create(:user)
      @round = FactoryBot.create(:round, label: "Round II")
      @question = FactoryBot.create(
        :question,
        round: @round,
        prompt: "What is your favorite color?",
        options: [
          FactoryBot.build(:option, prompt: "red", correct: false),
          FactoryBot.build(:option, prompt: "blue", correct: false),
          FactoryBot.build(:option, prompt: "green", correct: true),
          FactoryBot.build(:option, prompt: "orange", correct: false),
        ]
      )
    end

    it "shows the question prompt and answers" do
      sign_in(@user)
      visit question_path(@question)

      expect(page).to have_content("What is your favorite color?")
      @question.options.each do |option|
        path = "/questions/#{@question.id}/answer/#{option.id}"
        expect(page).to have_link(option.prompt, href: path)
      end
    end

    it "shows your answer if you've already answered" do
      answer_correct(@user, @question)
      sign_in(@user)
      visit question_path(@question)

      @question.options.each do |option|
        expect(page).to_not have_link(option.prompt)
      end
    end

    it "shows the percent correct from the round" do
      question_2 = FactoryBot.create(:question, round: @round)
      answer_correct(@user, @question)
      answer_incorrect(@user, question_2)
      next_question = FactoryBot.create(:question, round: @round)

      sign_in(@user)
      visit question_path(next_question)

      expect(page).to have_content("50.0%")
      expect(page).to have_content("1 / 2")
    end

    it "shows progress bar divs" do
      question_2 = FactoryBot.create(:question, round: @round)
      question_3 = FactoryBot.create(:question, round: @round)
      answer_correct(@user, @question)
      answer_incorrect(@user, question_2)
      answer_correct(@user, question_3)
      next_question = FactoryBot.create(:question, round: @round)

      sign_in(@user)
      visit question_path(next_question)

      expect(page).to have_css("#result-bar .correct", count: 2)
      expect(page).to have_css("#result-bar .incorrect", count: 1)
      expect(page).to have_css("#result-bar .remaining", count: 1)
    end

    it "shows the round label and question count" do
      question_2 = FactoryBot.create(:question, round: @round)
      question_3 = FactoryBot.create(:question, round: @round)
      answer_correct(@user, @question)
      answer_incorrect(@user, question_2)
      answer_correct(@user, question_3)
      next_question = FactoryBot.create(:question, round: @round)

      sign_in(@user)
      visit question_path(next_question)

      expect(page).to have_content("Round II : 4 / 4")
    end
  end
end
