class Subscription < ActiveRecord::Base
  belongs_to :user
  has_one :billing_address, :class_name => 'Address',  :conditions => { :kind => 'billing' }
  has_one :shipping_address, :class_name => 'Address', :conditions => { :kind => 'shipping' }

  validates_presence_of :plan_id # :stripe_customer_id ... hrm, hard to test in cucumber

  accepts_nested_attributes_for :user, :billing_address, :shipping_address

  attr_accessor :stripe_card_token, :card_number

  before_validation do
    self.shipping_address = nil if shipping_address && shipping_address.empty?
  end

  def plan
    @plan ||= Plan.new(plan_id)
  end

  def save_with_payment!
    if valid?
      customer = Stripe::Customer.create(email: user.email, plan: plan_id, card: stripe_card_token)
      self.stripe_customer_id = customer.id
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card: #{e.message}."
    false
  end
end
