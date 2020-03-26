Rails.application.routes.draw do
  devise_for :users

  root "home#home"

  resources "questions", :only => ["create", "show"] do
    post "answer/:answer_id", :to => "questions#answer", :as => "answer"
  end

  resources "rounds", :only => ["show"]
end
