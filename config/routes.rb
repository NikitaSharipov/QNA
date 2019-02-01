Rails.application.routes.draw do

  devise_for :users
  resources :questions do
    post :vote_up, on: :member
    post :vote_down, on: :member
    resources :answers, shallow: true do
      post :best, on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :badges, only: :index

  root to: "questions#index"
end
