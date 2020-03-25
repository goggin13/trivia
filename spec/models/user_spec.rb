require 'rails_helper'

RSpec.describe User, type: :model do
  describe "score" do
    before do
      @question = FactoryBot.create(:question)
      @user = User.create!(
        :email => "matt@example.com",
        :password => "password",
        :password_confirmation => "password",
      )
      @option = FactoryBot.create(:option, :question => @question, :correct => true)
      FactoryBot.create(
        :user_answer,
        :option => @option,
        :question => @question,
        :user => @user
      )
    end

    it "returns count of correct and total answers" do
      correct, total = @user.score
      expect(correct).to eq(1)
      expect(total).to eq(1)
    end
  end
end
