# Need to add these plans to Stripe, either using the Stripe management interface
# or using the api. See https://stripe.com/docs/tutorials/subscriptions

class Package
  PACKAGES = { tiny: 1000, small: 3500, medium: 7000, big: 20000, huge: 50000, silver: 100000, gold: 300000, platin: 600000 }

  attr_reader :id

  def initialize(id)
    raise "invalid package: #{id}" unless PACKAGES.key?(id.to_sym)
    @id = id.to_sym
  end

  def name
    id.to_s.camelize
  end

  def price
    PACKAGES[id]
  end

  def price_as_dollars
    price / 100
  end
end
