require 'rails_helper'

RSpec.describe "Users", type: :feature do
  before do
    FactoryBot.create(:round)
  end

  describe "sign up" do
    it "allows users to sign up" do
      visit new_user_registration_path
      fill_in 'Username', with: "hello"
      expect do
        click_button "Sign up"
      end.to change(User, :count).by(1)

      user = User.first!

      expect(user.username).to eq("hello")
    end

    it "rejects empty user names" do
      visit new_user_registration_path
      fill_in 'Username', with: ""
      expect do
        click_button "Sign up"
      end.to change(User, :count).by(0)

      expect(page).to have_content("Username can't be blank")
    end
  end

  describe "sign in" do
    it "allows users to sign in" do
      FactoryBot.create(:user, username: "test")
      visit new_user_session_path

      fill_in 'Username', with: "test"
      click_button "Sign in"

      expect(page).to have_content("Signed in successfully.")
    end

    it "is case insensitive sign in" do
      FactoryBot.create(:user, username: "test")
      visit new_user_session_path

      fill_in 'Username', with: "TEST"
      click_button "Sign in"

      expect(page).to have_content("Signed in successfully.")
    end

    it "rejects empty user names" do
      visit new_user_session_path
      fill_in 'Username', with: ""
      click_button "Sign in"

      expect(page).to have_content("Invalid Username or password.")
    end
  end
end
