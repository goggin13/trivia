Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "home#home"

  resources "questions", :only => ["create", "show"] do
    post "answer/:answer_id", :to => "questions#answer", :as => "answer"
  end
end
