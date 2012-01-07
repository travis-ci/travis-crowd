class OrdersAddActive < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.boolean :active, null: false, default: true
      t.datetime :cancelled_at
    end
  end
end

