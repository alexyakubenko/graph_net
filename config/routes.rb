Rails.application.routes.draw do
  root to: 'users#index'

  resources :user_sessions, only: [:create, :destroy]
  resources :home, only: [:index]

  resources :posts, except: :destroy do
    post :like, on: :member
  end

  resources :users, except: :destroy do
    member do
      get :messages
      post :request_friendship
      post :apply_friendship
      post :reject_friendship
      post :send_message
    end

    collection do
      post :create_attribute
      delete :delete_attribute
    end
  end

  get 'recommendations', to: 'recommendations#index', as: :recommendations
  get 'friends', to: 'users#friends', as: :friends
  get 'messages', to: 'users#messages', as: :messages

  get 'login' => 'user_sessions#new', as: :login

  post 'logout' => 'user_sessions#destroy', as: :logout
end
