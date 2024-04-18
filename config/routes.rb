Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  
  root "welcome#index"

  get "users/:id/geolocation/search", to: "geolocation#geolocate"

  post "/sign_in", to: "sessions#create"
  delete "/sign_out", to: "sessions#destroy"
  get "/auth/github/callback", to: "sessions#create"
  # get '/auth/google_oauth2', to: 'sessions#google_oauth2'
  # get '/auth/google_oauth2/callback', to: 'sessions#google_oauth2_callback'
  resources :users, except: :index do
    get "/dashboard", to: "users/dashboard#show"
    resources :tattoos, only: [:index, :create, :destroy], controller: "users/tattoos"
  end


  resources :artists, except: :index do
    get "/dashboard", to: "artists/dashboard#show"
    resources :tattoos, except: [:show, :index]
  end
end

  #             Prefix Verb   URI Pattern                                 Controller#Action
  #               root GET    /                                              welcome#index
  #            sign_in POST   /sign_in                                      sessions#create
  #           sign_out DELETE /sign_out                                     sessions#destroy
  #     user_dashboard GET    /users/:user_id/dashboard              users/dashboard#show
  #       user_tattoos GET    /users/:user_id/tattoos                  users/tattoos#index
  #                    POST   /users/:user_id/tattoos                  users/tattoos#create
  #        user_tattoo DELETE /users/:user_id/tattoos/:id               users/tattoos#destroy
  #       user_tattoos GET    /users/:user_id/tattoos                        tattoos#index
  #              users POST   /users                                           users#create
  #           new_user GET    /users/new                                       users#new
  #          edit_user GET    /users/:id/edit                                  users#edit
  #              user GET     /users/:id                                       users#show
  #                    PATCH  /users/:id                                       users#update
  #                    PUT    /users/:id                                       users#update
  #                    DELETE /users/:id                                       users#destroy


#               Prefix Verb   URI Pattern                                 Controller#Action
#     artist_dashboard GET    /artists/:artist_id/dashboard        artists/dashboard#show
#       artist_tattoos POST   /artists/:artist_id/tattoos                    tattoos#create
#    new_artist_tattoo GET    /artists/:artist_id/tattoos/new                tattoos#new
#   edit_artist_tattoo GET    /artists/:artist_id/tattoos/:id/edit           tattoos#edit
#        artist_tattoo PATCH  /artists/:artist_id/tattoos/:id                tattoos#update
#                      PUT    /artists/:artist_id/tattoos/:id                tattoos#update
#                      DELETE /artists/:artist_id/tattoos/:id                tattoos#destroy
#              artists POST   /artists                                       artists#create
#           new_artist GET    /artists/new                                   artists#new
#          edit_artist GET    /artists/:id/edit                              artists#edit
#               artist GET    /artists/:id                                   artists#show
#                      PATCH  /artists/:id                                   artists#update
#                      PUT    /artists/:id                                   artists#update
#                      DELETE /artists/:id                                   artists#destroy