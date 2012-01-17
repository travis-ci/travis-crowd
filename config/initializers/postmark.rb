settings = Rails.application.config.settings
config   = Rails.application.config.action_mailer

config.delivery_method   = :postmark
config.postmark_settings = { :api_key => settings.postmark.api_key }

p settings
p config
