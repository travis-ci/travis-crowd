namespace :stripe do
  task :create_plans do
    $: << 'app/models' << 'lib'

    require 'stripe'
    require 'package'
    require 'settings'

    settings = Settings.new.load('config/travis.yml', ENV['RAILS_ENV'] || 'development')
    Stripe.api_key = settings.stripe.secret_key

    Package::SUBSCRIPTIONS.keys.each do |id|
      plan = Package.new(id, true)
      Stripe::Plan.create(id: plan.id, name: plan.name, amount: plan.price, interval: 'month', currency: 'usd')
    end
  end
end
