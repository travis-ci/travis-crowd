settings = Rails.application.config.settings

Stripe.api_key = settings.stripe.secret_key
STRIPE_PUBLIC_KEY = settings.stripe.public_key
