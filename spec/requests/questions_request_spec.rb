require 'rails_helper'

RSpec.describe "Questions", type: :request do
  before do
    @user = User.create!(
      :email => "matt@example.com",
      :password => "password",
      :password_confirmation => "password",
    )
    sign_in @user
  end

  describe "POST /questions" do
    it "creates a new question" do
      headers = { "ACCEPT" => "application/json" }
      params = {
        "question": "A flashing red traffic light signifies that a driver should do what?",
        "A": "stop",
        "B": "speed up",
        "C": "proceed with caution",
        "D": "honk the horn",
        "answer": "A"
      }
      post "/questions", params: params, headers: headers

      expect(response.status).to eq(200)
      question = JSON.parse(response.body)

      expect(question["prompt"]).to eq("A flashing red traffic light signifies that a driver should do what?")
      expect(question["options"].length).to eq(4)
    end
  end

  describe "GET /questions/1" do
    before do
      @question = FactoryBot.create(:question, :prompt => "A flashing")
      @options = [
        @question.options.create!(:prompt =>"stop"),
        @question.options.create!(:prompt =>"speed up"),
        @question.options.create!(:prompt =>"proceed with caution"),
        @question.options.create!(:prompt =>"honk the horn", :correct => true),
      ]
    end

    it "shows 4 links to answer" do
      get "/questions/#{@question.id}"

      expect(response.status).to eq(200)

      expect(response.body).to include("A flashing")
      expect(response.body).to include("stop")
      expect(response.body).to include("speed up")
      expect(response.body).to include("proceed with caution")
      expect(response.body).to include("honk the horn")

      @options.each do |option|
        path = "/questions/#{@question.id}/answer/#{option.id}"
        expect(response.body).to include(path)
      end
    end

    xit "shows your answer if you have already answered" do
      headers = { "ACCEPT" => "application/json" }
      post "/questions/#{@question.id}/answer/#{@options[1].id}", :headers => headers
      expect(response.status).to eq(200)

      get "/questions/#{@question.id}"
      expect(response.status).to eq(200)

      expect(response.body).to include("You have already answered this question")
    end
  end

  describe "POST /questions/answer/<answer-id>" do
    before do
      @question = FactoryBot.create(:question, :prompt => "A flashing")
      @next_question = FactoryBot.create(:question)
      @options = [
        @question.options.create!(:prompt =>"stop"),
        @question.options.create!(:prompt =>"honk the horn", :correct => true),
      ]
    end

    it "saves the attempt and returns correct, and the next question" do
      headers = { "ACCEPT" => "application/json" }
      expect do
        post "/questions/#{@question.id}/answer/#{@options[0].id}",
          :headers => headers,
          :params => {:duration => 1.456}
      end.to change(UserAnswer, :count).by(1)

      expect(response.status).to eq(200)
      user_answer = UserAnswer.first!
      expect(user_answer.question_id).to eq(@question.id)
      expect(user_answer.option_id).to eq(@options[0].id)
      expect(user_answer.duration).to eq(1.456)

      body = JSON.parse(response.body)
      expect(body["correct"]).to eq(false)
      expect(body["correct_option"]["id"]).to eq(@options[1].id)
      expect(body["next_question"]["id"]).to eq(@next_question.id)
    end

    it "saves the attempt and returns correct" do
      headers = { "ACCEPT" => "application/json" }
      expect do
        post "/questions/#{@question.id}/answer/#{@options[1].id}", :headers => headers
      end.to change(UserAnswer, :count).by(1)

      expect(response.status).to eq(200)
      user_answer = UserAnswer.first!
      expect(user_answer.question_id).to eq(@question.id)
      expect(user_answer.option_id).to eq(@options[1].id)

      body = JSON.parse(response.body)
      expect(body["correct"]).to eq(true)
      expect(body["correct_option"]["id"]).to eq(@options[1].id)
      expect(body["next_question"]["id"]).to eq(@next_question.id)
    end
  end
end
