class Order < ActiveRecord::Base
  belongs_to :user
  has_one :billing_address,  as: 'addressable', class_name: 'Address', conditions: { kind: 'billing' }
  has_one :shipping_address, as: 'addressable', class_name: 'Address', conditions: { kind: 'shipping' }

  validates_presence_of :package # :stripe_customer_id ... hrm, hard to test in cucumber

  accepts_nested_attributes_for :user, :billing_address, :shipping_address

  attr_accessor :stripe_card_token, :card_number

  before_validation do
    self.shipping_address = nil if shipping_address && shipping_address.empty?
  end

  def package
    @package ||= Package.new(read_attribute(:package))
  end

  def save_with_payment!
    if valid?
      customer = create_customer!
      charge! unless subscription?
    end
    save!
  end

  def create_customer!
    attrs = { email: user.email, card: stripe_card_token }
    attrs.merge!(plan: package.id.to_s) if subscription?

    Stripe::Customer.create(attrs).tap do |customer|
      self.stripe_customer_id = customer.id
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating stripe customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card: #{e.message}."
    false
  end

  def charge!
    attrs = { description: package.id.to_s, amount: package.price, currency: 'usd', customer: stripe_customer_id }
    Stripe::Charge.create(attrs)
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating a stripe charge: #{e.message}"
    errors.add :base, "There was a problem with your credit card: #{e.message}."
    false
  end
end
