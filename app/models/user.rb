class User < ActiveRecord::Base
  devise :omniauthable
  has_many :subscriptions
  has_many :payments

  validates_presence_of :name, :email, :unless => :from_oauth?
  validates_uniqueness_of :email, :github_handle, :twitter_handle, :allow_blank => true

  class << self
    def find_or_create_from_oauth(data)
      data = Hashr.new(data)
      send(:"find_or_create_from_#{data.provider}_oauth", data)
    end

    def find_or_create_from_github_oauth(data)
      find_or_create_by_github_handle(data.info.nickname) do |user|
        user.update_attributes!(
          name: data.info.name,
          github_uid: data.uid,
          email: data.info.email,
          homepage: data.info.urls.Blog,
          from_oauth: true
        )
      end
    end

    def find_or_create_from_twitter_oauth(data)
      find_or_create_by_twitter_handle(data.info.nickname) do |user|
        user.update_attributes(
          name: data.info.name,
          twitter_uid: data.uid,
          homepage: data.info.urls.Website,
          from_oauth: true
        )
      end
    end
  end

  attr_accessor :from_oauth

  def from_oauth?
    !!@from_oauth
  end
end
