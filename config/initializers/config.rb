require 'settings'

settings = Settings.new(YAML.load(ENV['travis_config'] || {}))
settings.load('config/settings.yml', Rails.env) if settings.empty?

Rails.application.config.settings = settings
