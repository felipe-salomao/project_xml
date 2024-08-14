require 'sidekiq/web'

Rails.application.routes.draw do
  root 'reports#new'
  resources :reports, only: [:new, :create, :show]

  # Sidekiq
  mount Sidekiq::Web => '/sidekiq'
end
