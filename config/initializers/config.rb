require 'settings'

Rails.application.config.settings = Settings.new.load('config/settings.yml', Rails.env)
