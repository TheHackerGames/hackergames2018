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
  resources :meetings, only: %i[index]

  scope controller: :sign_up, path: 'sign_up', as: 'sign_up' do
    get :type_step
    get :meet_type_step
    get :name_step
    get :email_step
    get :location_step
    get :photo_step
    post :upload_photo
    get :shop_step
    get :date_step
    get :time_step
    get :final_step
  end
end
