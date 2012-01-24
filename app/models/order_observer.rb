require 'pusher'
Pusher.app_id, Pusher.key, Pusher.secret = Rails.application.config.settings[:pusher].values_at(:app_id, :key, :secret)

class OrderObserver < ActiveRecord::Observer
  def after_create(order)
    Pusher['orders_channel'].trigger! 'new_order', order: order.as_json
  end
end
