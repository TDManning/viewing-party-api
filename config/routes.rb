Rails.application.routes.draw do
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  get '/api/v1/movies/search', to: redirect('/api/v1/movies')

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :index]
      resources :sessions, only: :create
      resources :movies, only: [:index, :show]
      resources :viewing_parties, only: [:index, :create] do 
        resources :invitees, only: [:create], module: :viewing_parties
      end
    end
  end
end

#Endpoints 1 & 2
# Query Parameters for /api/v1/movies
# - ?filter=top_rated -> Fetches top-rated movies
# - ?query=<search_term> -> Fetches movies based on search term

#Endpoint 3
#/api/v1/viewing_parties

#Endpoint 4
#POST /api/v1/viewing_parties/:viewing_party_id/invitees