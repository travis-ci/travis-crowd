class Order < ActiveRecord::Base
  belongs_to :user
  has_one :billing_address,  as: 'addressable', class_name: 'Address', conditions: { kind: 'billing' }
  has_one :shipping_address, as: 'addressable', class_name: 'Address', conditions: { kind: 'shipping' }

  validates_presence_of :package

  accepts_nested_attributes_for :user, :billing_address, :shipping_address

  before_validation do
    self.total = package.price
  end

  class << self
    def total
      sum(:total).to_f / 100
    end
  end

  attr_accessor :card_number

  def package
    @package ||= Package.new(read_attribute(:package), subscription?)
  end

  def total_in_dollars
    total.to_f / 100
  end

  def save_with_payment!
    create_stripe_charge unless subscription?
    save!
  end

  JSON_ATTRS = [:subscription, :created_at, :comment]

  def as_json(options = {})
    super(only: JSON_ATTRS).merge(total: total_in_dollars, user: user.as_json, package: read_attribute(:package))
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
