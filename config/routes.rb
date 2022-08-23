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

  root 'posts#index'

  resources :posts, only: %i[index new create] do
    resources :likes, only: %i[create destroy]
  end

  resource :friendship_request, only: %i[create update destroy]
  resources :comments, only: %i[new create]

  get '/friends', to: 'users#friends'
  post '/posts/:id/like', to: 'likes#like', as: 'like'
  delete '/posts/:id/like', to: 'likes#unlike', as: 'destroy_like'
end
