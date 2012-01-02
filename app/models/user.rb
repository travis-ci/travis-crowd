class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable

  has_many :orders
  has_many :subscriptions, :class_name => 'Order', :conditions => { :subscription => true }
  has_many :packages,      :class_name => 'Order', :conditions => { :subscription => false }
  has_many :payments

  validates_presence_of :name, :email
  validates_uniqueness_of :email, :github_handle, :twitter_handle, allow_blank: true
end
