Rails.application.routes.draw do
  devise_for :users
  root "posts#index"

  resources :users, only: [ :show ] do
    member do
      get :followings
      get :followers
    end
    resources :posts, only: [ :index ]
  end

  resources :posts, only: [ :index, :new, :create, :show, :destroy, :edit, :update ] do
    resources :comments, only: [ :create ]
  end

  resources :comments, only: [ :destroy, :edit, :update ]
  resources :follows, only: [ :create, :destroy ] do
    member do
      patch :approve
    end
  end
end
