require 'geo_ip'

Travis::Application.routes.draw do
  root to: 'home#show'
  match 'company_packages', to: 'home#sponsoring_plans'
  match 'ads',              to: 'home#sponsoring_sizes'
  match 'imprint',          to: 'home#imprint'
  match 'ringtones',        to: 'home#ringtones'
  match 'sponsors',         to: 'home#sponsors'

  match 'packages/:package', as: :new_package, to: 'orders#new'
  match 'subscriptions/:package', as: :new_subscription, to: 'orders#new', subscription: true
  match 'geo_ip.json', to: GeoIP.new

  resources :orders, except: :new do
    get 'confirm', on: :member
  end

  resource :profile do
    get 'ringtones', on: :member
    match 'ringtones/:permalink.mp3', on: :member, action: :ringtone, as: :ringtone
  end

  match '/donations.json', to: 'orders#index', as: :donors

  devise_for :users, controllers: { omniauth_callbacks: 'sessions' }

  as :user do
    get 'users/sign_out', to: 'devise/sessions#destroy', as: :destroy_session
  end
end
