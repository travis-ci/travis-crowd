require 'cucumber/rails'

Capybara.default_selector = :css

ActionController::Base.allow_rescue = false


require 'database_cleaner'
require 'database_cleaner/cucumber'

DatabaseCleaner.strategy = :truncation
Cucumber::Rails::Database.javascript_strategy = :truncation

Before do
  DatabaseCleaner.start
end

After do |scenario|
  DatabaseCleaner.clean
end

require 'cucumber/fake_parameter_middleware'
Before do
  Cucumber::FakeParameterMiddleware.params = nil
end

require 'mocha'

World(Mocha::API)

Before do
  mocha_setup
end

After do
  begin
    mocha_verify
  ensure
    mocha_teardown
  end
end
