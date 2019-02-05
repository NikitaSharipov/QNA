Rails.application.routes.draw do

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      post :cancel
    end
  end

  devise_for :users
  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable], shallow: true do
      post :best, on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :badges, only: :index

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
