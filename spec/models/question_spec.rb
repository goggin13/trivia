require 'rails_helper'

RSpec.describe Question, type: :model do
  describe "self.create_from_json" do
    it "creates a question" do
      params = {
        "question": "A flashing red traffic light signifies that a driver should do what?",
        "A": "stop",
        "B": "speed up",
        "C": "proceed with caution",
        "D": "honk the horn",
        "answer": "A"
      }

      expect do
        expect do
          Question.create_from_json(params, FactoryBot.create(:round))
        end.to change(Question, :count).by(1)
      end.to change(Option, :count).by(4)

      question = Question.first!
      expect(question.prompt).to eq("A flashing red traffic light signifies that a driver should do what?")
      expect(question.options.count).to eq(4)
      expect(question.options.map(&:prompt)).to eq([
        "stop",
        "speed up",
        "proceed with caution",
        "honk the horn",
      ])
      expect(question.answer.prompt).to eq("stop")
    end
  end

  describe "answered?" do
    before do
      @question = FactoryBot.create(:question)
      @option = FactoryBot.create(:option, :question => @question)
      @user = FactoryBot.create(:user)
    end

    it "returns true if a user has answered" do
      FactoryBot.create(
        :user_answer,
        :user => @user,
        :option => @option,
        :question => @question
      )

      expect(@question.answered?(@user)).to eq(true)
    end

    it "returns false if a user has not answered" do
      expect(@question.answered?(@user)).to eq(false)
    end
  end
end
