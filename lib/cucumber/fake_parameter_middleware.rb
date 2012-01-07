require 'active_support/core_ext/hash/deep_merge'

module Cucumber
  class FakeParameterMiddleware
    class << self
      attr_accessor :params
    end

    delegate :params, to: 'self.class'

    def initialize(app)
      @app = app
    end

    def call(env)
      env['rack.request.form_hash'].deep_merge!(params) if env.key?('rack.request.form_hash') && params
      @app.call(env)
    end
  end
end
