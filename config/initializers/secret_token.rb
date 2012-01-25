# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
dev_secret_token = 'ceebd28ebf21ac31d55796902b5bf861e9a027580ca324387a0f2da71fb2f8fd9a896ada18b3398dc4bd464b9372e1f7d2057c7e1a10a24c42a03b7fcd577850'

Travis::Application.config.secret_token = Rails.application.config.settings.secret_token || dev_secret_token
