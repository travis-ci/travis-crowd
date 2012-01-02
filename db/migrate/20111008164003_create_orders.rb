class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.string :package
      t.boolean :subscription, null: false, default: false
      t.string :stripe_customer_id
      t.timestamps
    end
  end
end
