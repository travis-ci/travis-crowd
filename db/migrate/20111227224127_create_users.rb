class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.database_authenticatable
      t.recoverable
      t.rememberable
      t.trackable

      t.string :name
      t.string :email
      t.integer :twitter_uid
      t.string :twitter_handle
      t.integer :github_uid
      t.string :github_handle
      t.string :homepage
      t.string :description

      t.string :stripe_customer_id

      t.timestamps
    end
  end
end
