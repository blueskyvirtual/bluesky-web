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

  resources :roster, only: %i[index show], as: :users
end
