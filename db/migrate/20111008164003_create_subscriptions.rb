class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user
      t.string :plan_id
      t.string :stripe_customer_id
      t.timestamps
    end
  end
end
