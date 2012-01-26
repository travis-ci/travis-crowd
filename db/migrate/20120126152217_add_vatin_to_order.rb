class AddVatinToOrder < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.string :vatin
    end
  end
end
