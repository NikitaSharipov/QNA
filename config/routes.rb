Rails.application.routes.draw do

  concern :votable do
    member do
      patch :create_comment
      delete :destroy_comment

    end
  end

  concern :commentable do
    member do
      post :vote_up
      post :vote_down
      post :cancel
    end
  end

  devise_for :users
  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true do
      post :best, on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :badges, only: :index

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
