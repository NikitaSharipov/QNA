Rails.application.routes.draw do

  devise_for :users
  resources :questions do
    resources :answers, shallow: true do
      post :best, on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :badges, only: :index

  root to: "questions#index"
end
