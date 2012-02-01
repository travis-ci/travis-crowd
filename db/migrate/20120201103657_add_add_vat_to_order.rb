class AddAddVatToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :add_vat, :boolean

  end
end
