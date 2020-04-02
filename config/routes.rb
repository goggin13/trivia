Rails.application.routes.draw do
  devise_for :users

  root "home#home"

  resources "questions", :only => ["create", "show"] do
    post "answer/:answer_id", :to => "questions#answer", :as => "answer"
  end

  get "/games/:game_id" => "home#home", :as => "game"

  resources "rounds", :only => ["show"]
end
