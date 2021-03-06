Rails.application.routes.draw do
  root to: 'users#index'

  resources :user_sessions, only: [:create, :destroy]

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

    post :update_profile_attributes, on: :collection
  end

  get 'autocomplete_attribute', to: 'attributes#autocomplete_attribute_value', as: :autocomplete_attribute

  get 'recommendations', to: 'recommendations#index', as: :recommendations
  get 'friends(/:id)', to: 'users#friends', as: :friends
  get 'messages', to: 'users#messages', as: :messages

  get 'login' => 'user_sessions#new', as: :login

  post 'logout' => 'user_sessions#destroy', as: :logout
end
