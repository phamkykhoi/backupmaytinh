Rails.application.routes.draw do
  devise_for :admin

  root to: "home#index"

  get "/auth/:provider/callback", to: "users#create", as: :auth_callback
  get "/sign_in", to: "sessions#new"
  delete "/sign_out", to: "sessions#destroy"

  resources :sessions, only: [:create]
  resources :posts, only: [:new, :create, :show]
  resources :temporally_photos, only: [:create]
  resources :cameras, only: [:index]
  resources :tags, only: [:index]
  resources :places, only: [:index]
  resources :users, only: [:index]

  namespace :admin do
    root to: "posts#index"
    resources :photos, only: [:show]
    resources :users, only: [:index, :update]
    resources :posts, only: [:index, :update, :destroy]
    resources :notifications, only: [:index, :create]
    resources :bulletins
  end

  namespace :v2, defaults: {format: :json} do
    post "login", to: "sessions#login"
    post "logout", to: "sessions#logout"
    post "password_reset", to: "users#password_reset"
    get "point_up", to: "app_driver_histories#point_up"

    resources :app_driver_histories, only: [:index]
    resources :sessions, only: [:create]
    resources :bans, only: [:create]
    resources :photos, only: [:create]
    resources :followerships, only: [:index, :create, :destroy]
    resources :supporterships, only: [:create, :index]
    resources :comments, only: [:create, :index, :destroy]
    resources :posts, only: [:index, :create, :show, :destroy]
    resources :users, only: [:index, :create, :show, :update]
    resources :rankings, only: [:index, :show]
    resources :bulletins, only: [:index]
    resources :activities, only: [:index]
    resources :tickets, only: [:show]
    resources :support_subtotals, only: [:index]
    resources :ranking_histories, only: [:index]
    resource :location, only: [:show]
    resources :cameras, only: [:index]
    resources :tags, only: [:index]

    namespace :m do
      resources :genres, only: [:index]
      resource :version, only: [:show]
    end
  end

  resource :bulletin, only: [:show]
end
