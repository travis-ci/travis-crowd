class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable

  has_many :orders
  has_many :subscriptions, :class_name => 'Order', :conditions => { :subscription => true }
  has_many :packages,      :class_name => 'Order', :conditions => { :subscription => false }
  has_many :payments

  validates_presence_of :name, :email
  validates_uniqueness_of :email, :github_handle, :twitter_handle, allow_blank: true

  attr_accessor :stripe_card_token

  def save_with_customer!(plan)
    create_stripe_customer(plan) unless stripe_customer_id
    save!
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
