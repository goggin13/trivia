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
          Question.create_from_json(params)
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

  describe "#next" do
    it "returns the next question by id" do
      q1 = FactoryBot.create(:question)
      q2 = FactoryBot.create(:question)
      q3 = FactoryBot.create(:question)

      expect(q1.next).to eq(q2)
      expect(q2.next).to eq(q3)
      expect(q3.next).to eq(nil)
    end
  end

  describe "answered?" do
    before do
      @question = FactoryBot.create(:question)
      @option = FactoryBot.create(:option, :question => @question)
      @user = User.create!(
        :email => "matt@example.com",
        :password => "password",
        :password_confirmation => "password",
      )
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
