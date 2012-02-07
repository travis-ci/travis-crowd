class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :protect_production

  protected

    def protect_production
      if request.host == 'travis-crowd-staging.herokuapp.com'
        authenticate_or_request_with_http_basic do |username, password|
          username == 'travis' && password == 'crowd'
        end
      end
    end
end

