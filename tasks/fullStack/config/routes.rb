require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app

  resources :shop_statistics, only: [:show]
  resources :reviews, only: [:index, :new, :create] do
  end
end
