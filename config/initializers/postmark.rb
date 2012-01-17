if Rails.env.production?
  settings = Rails.application.config.settings

  # ActionMailer::Base.delivery_method   = :postmark
  # ActionMailer::Base.postmark_settings = { :api_key => settings.postmark.api_key }

  mailer  = ActionMailer::Base
  api_key = Rails.application.config.settings.postmark.api_key

  mailer.delivery_method = :smtp
  mailer.smtp_settings = {
    address:   'smtp.postmarkapp.com',
    user_name: api_key,
    password:  api_key,
    domain:    'love.travis-ci.org'
  }
end
