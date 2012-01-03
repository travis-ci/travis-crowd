class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.belongs_to :addressable, :polymorphic => true

      t.string :kind
      t.string :name
      t.string :street
      t.string :zip
      t.string :city
      t.string :state
      t.string :country

      t.timestamps
    end
  end
end
