class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable

  has_many :orders
  has_many :subscriptions, class_name: 'Order', conditions: { subscription: true  }, order: 'created_at DESC'
  has_many :packages,      class_name: 'Order', conditions: { subscription: false }, order: 'created_at DESC'
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

  def charge(package)
    stripe_create_charge(package)
  end

  def subscribe(package)
    stripe_set_subscription(package)
    update_attributes!(stripe_plan: package) if valid?
  end

  def cancel_subscription
    stripe_cancel_subscription
  end

  def save_with_customer!
    stripe_create_customer unless stripe_customer_id
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

    def stripe_create_customer
      customer = Stripe::Customer.create(email: email, card: stripe_card_token)
      self.stripe_customer_id = customer.id
    rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while creating stripe customer: #{e.message}"
      errors.add :base, "There was a problem with your credit card: #{e.message}."
      false
    end

    def stripe_create_charge(package)
      Stripe::Charge.create(description: "#{email} (#{package.id.to_s})", amount: package.price, currency: 'usd', customer: stripe_customer_id)
    rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while creating a stripe charge: #{e.message}"
      errors.add :base, "There was a problem with your credit card: #{e.message}."
      false
    end

    def stripe_set_subscription(package)
      Stripe::Customer.retrieve(stripe_customer_id).update_subscription(plan: package.id)
    end

    def stripe_cancel_subscription
      Stripe::Customer.retrieve(stripe_customer_id).cancel_subscription
    end
end
