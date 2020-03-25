require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "home" do
    it "returns a 200" do
      get "/"
      expect(response.status).to eq(200)
    end
  end
end
