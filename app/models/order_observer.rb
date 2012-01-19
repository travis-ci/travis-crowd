class OrderObserver < ActiveRecord::Observer
  def after_create(order)
    OrderStream.send_json(order: order.as_json) 
  end
end
