Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root 'static_pages#splash'

  devise_scope :user do
    get '/sign_in', to: 'devise/sessions#new'
    get '/sign_up', to: 'devise/registrations#new'
  end

  unauthenticated :user do
    root to: redirect('/sign_in'), as: :unauthenticated_root
  end

  root 'posts#index'

  resources :posts, only: %w[index]
end
