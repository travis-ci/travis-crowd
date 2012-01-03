class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.string :package
      t.boolean :subscription, null: false, default: false
      t.timestamps
    end
  end
end