# frozen_string_literal: true

Rails.application.routes.draw do
  resources :keywords, only: %i[new create index] do
    get :search_result, on: :member, as: :search_result
  end

  get 'sign_up' => 'registrations#new'
  post 'sign_up', to: 'registrations#create', as: :signup
  get 'log_in' => 'sessions#new'
  post 'log_in' => 'sessions#create', as: :login

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'keywords#new'
end
