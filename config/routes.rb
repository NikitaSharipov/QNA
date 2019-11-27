require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

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
  resources :questions, concerns: %i[votable commentable], shallow: true do
    resources :subscriptions, only: %i[create destroy]
    resources :answers, concerns: %i[votable commentable] do
      post :best, on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :badges, only: :index

  resources :advanced_registrations, only: %i[new create]

  resources :searchs, only: [:index]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy], shallow: true do
        resources :answers, only: %i[index show create update destroy]
      end
    end
  end

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
