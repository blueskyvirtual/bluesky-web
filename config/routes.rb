# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :user,
             path: '',
             path_names: {
               sign_in:   'login',
               sign_out:  'logout',
               sign_up:   'join'
             },
             controllers: {
               # omniauth_callbacks: 'omniauth_callbacks',
               # passwords:          'passwords',
               registrations:      'registrations'
             }

  devise_scope :user do
    get '/welcome', to: 'registrations#show'
  end

  root to: 'home#index'

  mount ActionCable.server => '/cable'

  # API Namespace
  namespace :api do
    namespace :v2 do
      resources :airports, only: %i[show]

      resources :countries, only: %i[index show] do
        resources :regions, only: %i[index show]
      end
    end
  end

  # Frontend Namespace
  #
  resources :airlines do
    get 'route_map', to: 'airlines#route_map'
    resources :flights, except: :index, controller: 'airlines/flights' do
      get 'map'
    end
  end

  get 'airlines/flights/upload',
      to: 'airlines/flights#upload', as: 'airline_flight_upload'

  resources :roster, as: :users do
    post 'send_password_reset'
  end

  resources :schedule, only: :index do
    collection do
      match 'search' => 'schedule#search', via: %i[get post], as: :search
    end
  end
end
