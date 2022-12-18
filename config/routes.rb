Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root 'static_pages#splash'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :users, only: %i[index show]

  devise_scope :user do
    get '/sign_in', to: 'devise/sessions#new'
    get '/sign_up', to: 'devise/registrations#new'
  end

  unauthenticated :user do
    root to: redirect('/sign_in'), as: :unauthenticated_root
  end

  root 'feeds#show'

  resources :posts, only: %i[index new create show] do
    resources :likes, only: %i[create], module: :posts
    resource :likes, only: %i[destroy], module: :posts
  end

  resources :comments, only: %i[new create edit update index show] do
    resources :likes, only: %i[create], module: :comments
    resource :likes, only: %i[destroy], module: :comments
  end

  # resources :likes, only: %i[destroy]
  resource :likes, only: %i[destroy]

  resource :friendship_request, only: %i[create update destroy]
  resource :feed, only: %i[show]
  resource :windowed_comments, only: %i[show]

  get '/friends', to: 'users#friends'
  get '/load', to: 'comments#load'
end

