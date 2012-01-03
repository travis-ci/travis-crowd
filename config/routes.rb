Saas::Application.routes.draw do
  root to: 'home#show'

  match 'packages/:package', as: :new_order, to: 'orders#new'

  resources :orders, except: :new

  match '/profile', to: 'profiles#show', as: :profile
  match '/donators.json', to: 'profiles#index', as: :donators

  devise_for :users, controllers: { omniauth_callbacks: 'sessions' }

  as :user do
    get 'users/sign_out', to: 'devise/sessions#destroy', as: :destroy_session
  end
end
