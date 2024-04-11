Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  
  root "welcome#index"

  post "/sign_in", to: "sessions#create"
  delete "/sign_out", to: "sessions#destroy"

  resources :users, except: :index do
    get "/dashboard", to: "users/dashboard#show"
    resources :tattoos, only: :index
    resources :appointments, only: [:index]
  end

  resources :artists, except: :index do
    get "/dashboard", to: "artists/dashboard#show"
    resources :tattoos, except: [:show, :index]
    resources :appointments, only: :index
  end
end

#               Prefix Verb   URI Pattern                                           Controller#Action
#                 root GET    /                                                        welcome#index
#              sign_in POST   /sign_in(.:format)                                      sessions#create
#             sign_out DELETE /sign_out(.:format)                                     sessions#destroy
#       user_dashboard GET    /users/:user_id/dashboard(.:format)              users/dashboard#show
#         user_tattoos GET    /users/:user_id/tattoos(.:format)                        tattoos#index
#    user_appointments GET    /users/:user_id/appointments(.:format)              appointments#index
#                users POST   /users(.:format)                                           users#create
#             new_user GET    /users/new(.:format)                                       users#new
#            edit_user GET    /users/:id/edit(.:format)                                  users#edit
#                user GET    /users/:id(.:format)                                        users#show
#                      PATCH  /users/:id(.:format)                                       users#update
#                      PUT    /users/:id(.:format)                                       users#update
#                      DELETE /users/:id(.:format)                                       users#destroy


#               Prefix Verb   URI Pattern                                           Controller#Action
#     artist_dashboard GET    /artists/:artist_id/dashboard(.:format)        artists/dashboard#show
#       artist_tattoos POST   /artists/:artist_id/tattoos(.:format)                    tattoos#create
#    new_artist_tattoo GET    /artists/:artist_id/tattoos/new(.:format)                tattoos#new
#   edit_artist_tattoo GET    /artists/:artist_id/tattoos/:id/edit(.:format)           tattoos#edit
#        artist_tattoo PATCH  /artists/:artist_id/tattoos/:id(.:format)                tattoos#update
#                      PUT    /artists/:artist_id/tattoos/:id(.:format)                tattoos#update
#                      DELETE /artists/:artist_id/tattoos/:id(.:format)                tattoos#destroy
#  artist_appointments GET    /artists/:artist_id/appointments(.:format)          appointments#index
#              artists POST   /artists(.:format)                                       artists#create
#           new_artist GET    /artists/new(.:format)                                   artists#new
#          edit_artist GET    /artists/:id/edit(.:format)                              artists#edit
#               artist GET    /artists/:id(.:format)                                   artists#show
#                      PATCH  /artists/:id(.:format)                                   artists#update
#                      PUT    /artists/:id(.:format)                                   artists#update
#                      DELETE /artists/:id(.:format)                                   artists#destroy