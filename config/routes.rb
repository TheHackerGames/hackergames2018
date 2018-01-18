Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  get 'profile', to: 'users#profile'

  resources :users, only: %i[update]
  resources :availabilities, only: %i[index new edit create update] do
    get :search_form, on: :collection
    get :search, on: :collection
    post :request_meeting, on: :member
  end
  resources :meetings, only: [:create, :index]
end
