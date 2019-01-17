Rails.application.routes.draw do

  devise_for :users
  resources :questions, shallow: true do
    resources :answers, shallow: true do
      post :best, on: :member
    end
  end

  resources :attachments, only: :destroy

  root to: "questions#index"
end
