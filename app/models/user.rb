class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable

  has_many :orders
  has_many :subscriptions, class_name: 'Order', conditions: { subscription: true }
  has_many :packages,      class_name: 'Order', conditions: { subscription: false }
  has_many :payments

  validates_presence_of :name, :email
  validates_uniqueness_of :email, :github_handle, :twitter_handle, allow_blank: true

  class << self
    def users_count
      where(:company => false).count
    end

    def companies_count
      where(:company => true).count
    end
  end

  attr_accessor :stripe_card_token

  def save_with_customer!(plan)
    create_stripe_customer(plan) unless stripe_customer_id
    save!
  end

  def gravatar_url(options = { size: 120 })
    Gravatar.new(email).image_url(options)
  end

  ANONYMOUS  = { name: 'Anonymous', twitter_handle: '', github_handle: '', homepage: '', description: '' }
  JSON_ATTRS = [:name, :twitter_handle, :github_handle, :homepage]

  def as_json(options = {})
    display? ? super(only: JSON_ATTRS).merge(gravatar_url: gravatar_url) : ANONYMOUS
  end

  protected

    def create_stripe_customer(plan)
      customer = Stripe::Customer.create(email: email, card: stripe_card_token, plan: plan)
      self.stripe_plan = plan
      self.stripe_customer_id = customer.id
    rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while creating stripe customer: #{e.message}"
      errors.add :base, "There was a problem with your credit card: #{e.message}."
      false
    end
end
