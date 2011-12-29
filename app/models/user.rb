class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable

  has_many :subscriptions
  has_many :payments

  validates_presence_of :name, :email
  validates_uniqueness_of :email, :github_handle, :twitter_handle, :allow_blank => true
end
