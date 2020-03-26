require 'rails_helper'

RSpec.describe "Rounds", type: :feature do
  describe "round page" do
    before do
      @logged_in_user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user)
      @round = FactoryBot.create(:round, label: "Round II")
      @questions = (0..3).map do
        FactoryBot.create( :question, round: @round)
      end
    end

    it "shows all the stats for the round" do
      @questions.each do |q|
        answer_correct(@logged_in_user, q)
        answer_incorrect(@other_user, q)
      end

      sign_in(@logged_in_user)
      visit round_path(@round)

      expect(page).to have_content("Round II")

      expect(page).to have_content(@logged_in_user.email)
      expect(page).to have_content("100.0%")
      expect(page).to have_content(@other_user.email)
      expect(page).to have_content("0.0%")
    end
  end
end
