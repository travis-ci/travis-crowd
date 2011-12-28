class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.belongs_to :user
      t.belongs_to :subscription
      t.integer :amount
      t.timestamps
    end
  end
end
