require 'rails_helper'

RSpec.describe "Questions", type: :request do
  def post_answer(question, option, params={})
    headers = { "ACCEPT" => "application/json" }
    post "/questions/#{question.id}/answer/#{option.id}",
      :headers => headers,
      :params => {:duration => 1.456}
  end

  before do
    @user = User.create!(
      :email => "matt@example.com",
      :password => "password",
      :password_confirmation => "password",
    )
    sign_in @user
  end

  describe "POST /questions/answer/<answer-id>" do
    before do
      @round = FactoryBot.create(:round)
      @question = FactoryBot.create(
        :question,
        prompt: "A flashing",
        round: @round,
        options: [
          FactoryBot.build(:option, :prompt =>"stop"),
          FactoryBot.build(:option, :prompt =>"honk the horn", :correct => true),
        ]
      )

      @next_question = FactoryBot.create(:question, round: @round)
      @options = @question.options
    end

    it "saves the attempt and duration and returns whether it was correct" do
      expect do
        post_answer(@question, @options[0], duration: 1.456)
      end.to change(UserAnswer, :count).by(1)

      expect(response.status).to eq(200)
      user_answer = UserAnswer.first!
      expect(user_answer.question_id).to eq(@question.id)
      expect(user_answer.option_id).to eq(@options[0].id)
      expect(user_answer.duration).to eq(1.456)

      body = JSON.parse(response.body)
      expect(body["correct"]).to eq(false)
      expect(body["correct_option"]["id"]).to eq(@options[1].id)
    end

    it "saves the attempt and returns correct" do
      expect do
        post_answer(@question, @options[1])
      end.to change(UserAnswer, :count).by(1)

      expect(response.status).to eq(200)
      user_answer = UserAnswer.first!
      expect(user_answer.question_id).to eq(@question.id)
      expect(user_answer.option_id).to eq(@options[1].id)

      body = JSON.parse(response.body)
      expect(body["correct"]).to eq(true)
      expect(body["correct_option"]["id"]).to eq(@options[1].id)
    end

    it "returns a redirect to the next question if the round is not complete" do
      post_answer(@question, @options[1])
      expect(response.status).to eq(200)

      body = JSON.parse(response.body)
      expect(body["redirect"]).to eq(question_path(@next_question))
    end

    it "returns a redirect to the next question if the round is not complete" do
      answer_correct(@user, @question)
      post_answer(@next_question, @next_question.options[1])
      expect(response.status).to eq(200)

      body = JSON.parse(response.body)
      expect(body["redirect"]).to eq(round_path(@round))
    end
  end
end
