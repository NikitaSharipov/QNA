Rails.application.routes.draw do

  use_doorkeeper
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

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true do
      post :best, on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :badges, only: :index

  resources :advanced_registrations, only: [:new, :create]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end

      resources :questions, only: [:index]
    end
  end

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
