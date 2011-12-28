Saas::Application.routes.draw do
  root to: 'home#index'

  resources :subscriptions

  match '/profile', :to => 'profile#show'
  devise_for :users, controllers: { omniauth_callbacks: 'sessions' }

  as :user do
    get 'users/sign_out', to: 'devise/sessions#destroy', as: :destroy_session
  end
end
