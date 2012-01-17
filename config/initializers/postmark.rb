if Rails.env.production?
  settings = Rails.application.config.settings

  ActionMailer::Base.delivery_method   = :postmark
  ActionMailer::Base.postmark_settings = { :api_key => settings.postmark.api_key }
end
