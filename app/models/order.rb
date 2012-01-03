class Order < ActiveRecord::Base
  belongs_to :user
  has_one :billing_address,  as: 'addressable', class_name: 'Address', conditions: { kind: 'billing' }
  has_one :shipping_address, as: 'addressable', class_name: 'Address', conditions: { kind: 'shipping' }

  validates_presence_of :package

  accepts_nested_attributes_for :user, :billing_address, :shipping_address

  attr_accessor :card_number

  before_validation do
    self.shipping_address = nil if shipping_address && shipping_address.empty?
  end

  def package
    @package ||= Package.new(read_attribute(:package))
  end

  def total_in_dollars
    package.price_in_dollars
  end

  def save_with_payment!
    create_stripe_charge unless subscription?
    save!
  end

  protected

    def create_stripe_charge
      Stripe::Charge.create(description: "#{user.email} (#{package.id.to_s})", amount: package.price, currency: 'usd', customer: user.stripe_customer_id)
    rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while creating a stripe charge: #{e.message}"
      errors.add :base, "There was a problem with your credit card: #{e.message}."
      false
    end
end
