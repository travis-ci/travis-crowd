# Need to add these plans to Stripe, either using the Stripe management interface
# or using the api. See https://stripe.com/docs/tutorials/subscriptions

class Package
  PACKAGES      = { nano: 100, tiny: 1000, small: 3500, medium: 7000, big: 20000, huge: 50000, silver: 100000, gold: 300000, platinum: 600000 }
  SUBSCRIPTIONS = { small: 1000, medium: 1500, big: 2500 }

  class << self
    def price(package, subscription = false)
      (subscription ? SUBSCRIPTIONS : PACKAGES)[package.to_sym] / 100
    end
  end

  attr_reader :id, :subscription

  def initialize(id, subscription)
    raise "invalid package: #{id}" unless PACKAGES.key?(id.to_sym)
    @id = id.to_sym
    @subscription = subscription
  end

  def subscription?
    !!subscription
  end

  def name
    id.to_s.camelize
  end

  def price
    subscription? ? SUBSCRIPTIONS[id] : PACKAGES[id]
  end

  def features
    FEATURES[id]
  end

  def price_in_dollars
    price.to_f / 100
  end

  def vat
    raise "cannot calculate VAT without riscing rounding issues" unless price % 100 == 0
    (price / 100) * 19
  end

  def price_with_vat_in_dollars
    (price + vat).to_f / 100
  end

  def price_with_vat
    price + vat
  end

  def sort_order
    PACKAGES.keys.index(id)
  end
end
