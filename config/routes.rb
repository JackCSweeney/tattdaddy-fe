Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :users, except: :index do
    get "/dashboard", to: "user/dashboard#show"
  end

  resources :artists, except: :index do
    get "/dashboard", to: "artist/dashboard#show"
  end
end

  #           Prefix Verb   URI Pattern                                      Controller#Action
  #   user_dashboard GET    /users/:user_id/dashboard(.:format)              user/dashboard#show
  #            users POST   /users(.:format)                                 users#create
  #         new_user GET    /users/new(.:format)                             users#new
  #        edit_user GET    /users/:id/edit(.:format)                        users#edit
  #             user GET    /users/:id(.:format)                             users#show
  #                  PATCH  /users/:id(.:format)                             users#update
  #                  PUT    /users/:id(.:format)                             users#update
  #                  DELETE /users/:id(.:format)                             users#destroy
  # artist_dashboard GET    /artists/:artist_id/dashboard(.:format)          artist/dashboard#show
  #          artists POST   /artists(.:format)                               artists#create
  #       new_artist GET    /artists/new(.:format)                           artists#new
  #      edit_artist GET    /artists/:id/edit(.:format)                      artists#edit
  #           artist GET    /artists/:id(.:format)                           artists#show
  #                  PATCH  /artists/:id(.:format)                           artists#update
  #                  PUT    /artists/:id(.:format)                           artists#update
  #                  DELETE /artists/:id(.:format)                           artists#destroy