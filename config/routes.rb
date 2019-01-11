Rails.application.routes.draw do

  devise_for :users
  resources :questions, shallow: true do
    resources :answers, shallow: true
  end

  root to: "questions#index"
end
