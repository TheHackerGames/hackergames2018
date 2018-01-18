Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  get 'profile', to: 'users#profile'

  resources :users, only: [:update]
end
