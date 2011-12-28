settings = Hashr.new(YAML.load(File.read('config/settings.yml')))

Devise.setup do |c|
  require 'devise/orm/active_record'

  c.http_authenticatable = true

  c.omniauth :github, settings.github.client_id, settings.github.client_secret, :scope => settings.github.scope
  c.omniauth :twitter, settings.twitter.client_id, settings.twitter.client_secret
end
