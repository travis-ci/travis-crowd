class OrdersAddMessage < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.text :message
    end
  end
end
