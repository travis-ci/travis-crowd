if Rails.env.production?
  settings = Rails.application.config.settings

  # ActionMailer::Base.delivery_method   = :postmark
  # ActionMailer::Base.postmark_settings = { :api_key => settings.postmark.api_key }

  ActionMailer::Base.delivery_method   = :smtp
  ActionMailer::Base.postmark_settings = {
    address:   'smtp.postmarkapp.com',
    user_name: settings.postmark.api_key,
    password:  settings.postmark.api_key,
    domain:    'love.travis-ci.org'
  }
end
