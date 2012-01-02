Saas::Application.routes.draw do
  root to: 'home#index'

  resources :orders

  match '/profile', to: 'profile#show', as: :profile
  devise_for :users, controllers: { omniauth_callbacks: 'sessions' }

  as :user do
    get 'users/sign_out', to: 'devise/sessions#destroy', as: :destroy_session
  end
end
