Rails.application.routes.draw do
  devise_for :users
  root "posts#index"
  resources :users do
    resources :posts, only: [ :index ]
  end
  resources :posts, only: [ :index, :new, :create, :show, :destroy ]
end
