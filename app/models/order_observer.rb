class OrderObserver < ActiveRecord::Observer
  def after_create(order)
    Pusher['orders_channel'].trigger! 'new_order', order: order.as_json
  end
end
