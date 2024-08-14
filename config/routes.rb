require 'sidekiq/web'

Rails.application.routes.draw do
  root 'reports#new'

  # Autenticacao de usuarios
  devise_for :users

  # Sidekiq
  mount Sidekiq::Web => '/sidekiq'

  # Relatorios
  resources :reports, only: [:new, :create, :show]
end
