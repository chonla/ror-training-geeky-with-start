require "sidekiq/web"

Rails.application.routes.draw do
  resources :posts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
  #   resources :posts
  # end

  mount Sidekiq::Web => "/sidekiq"

  # Defines the root path route ("/")
  # resources :posts # RESTful enabling all
  resources :posts, only: [:index, :show]

  
  root "posts#index"
end
