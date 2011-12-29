# Need to add these plans to Stripe, either using the Stripe management interface
# or using the api. See https://stripe.com/docs/tutorials/subscriptions

class Plan
  PLANS = { tiny: 10, small: 35, medium: 70, big: 200, huge: 500 }

  attr_reader :id

  def initialize(id)
    raise "invalid plan id: #{id}" unless PLANS.key?(id.to_sym)
    @id = id.to_sym
  end

  def name
    "#{id.to_s.camelize} subscription"
  end

  def price
    PLANS[id]
  end
end
