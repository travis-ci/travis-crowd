settings = Hashr.new(YAML.load(File.read('config/settings.yml')))

Stripe.api_key = settings.stripe.secret_key
STRIPE_PUBLIC_KEY = settings.stripe.public_key
