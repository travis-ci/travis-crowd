class Subscription < ActiveRecord::Base
  belongs_to :user
  has_one :billing_address, :class_name => 'Address'
  has_one :shipping_address, :class_name => 'Address'

  validates_presence_of :plan

  accepts_nested_attributes_for :user, :billing_address, :shipping_address

  attr_accessor :stripe_card_token, :card_number

  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(description: user.email, plan: plan, card: stripe_card_token)
      self.stripe_customer_token = customer.id
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card: #{e.message}."
    false
  end
end
