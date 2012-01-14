Travis::Application.routes.draw do
  root to: 'home#show'

  match 'packages/:package', as: :new_package, to: 'orders#new'
  match 'subscriptions/:package', as: :new_subscription, to: 'orders#new', subscription: true

  resources :orders, except: :new do
    get 'confirm', on: :member
  end

  resource :profile do
    get 'ringtones', on: :member
  end

  match '/donations.json', to: 'orders#index', as: :donors

  devise_for :users, controllers: { omniauth_callbacks: 'sessions' }

  as :user do
    get 'users/sign_out', to: 'devise/sessions#destroy', as: :destroy_session
  end
end
