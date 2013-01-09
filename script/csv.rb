APP_PATH = File.expand_path('../../config/application',  __FILE__)
require File.expand_path('../../config/environment',  __FILE__)

require 'csv'

orders = Order.where('created_at >= ?', Date.new(2012, 8, 1))
orders = orders.includes(:user, :billing_address)

data = orders.map do |order|
  address = order.billing_address
  user = order.user
  {
    package:         order.package.id,
    subscription:    order.package.subscription,
    total:           order.total,
    name:            user.name,
    email:           user.email,
    twitter_handle:  user.twitter_handle,
    github_handle:   user.github_handle,
    address_name:    address.name,
    address_street:  address.street,
    address_zip:     address.zip,
    address_city:    address.city,
    address_state:   address.state,
    address_country: address.country,
    stripe_customer_id: user.stripe_customer_id
  }
end

if data.empty?
  puts 'no data found'
else
  data = [data.first.keys.map(&:to_s)] + data.map(&:values)
  lines = data.map { |line| line.to_csv }
  puts lines.join
end
