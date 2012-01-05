require 'settings'

settings = Settings.new(YAML.load(ENV['travis_config'] || ''))
settings.load('config/travis.yml', Rails.env)

Rails.application.config.settings = settings
