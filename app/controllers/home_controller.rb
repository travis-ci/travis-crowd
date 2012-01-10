class HomeController < ApplicationController
  protected

    helper_method :results, :stats

    def results
      @results ||= { users: User.users_count, companies: User.companies_count, total: Order.total }
    end

    def stats
      @stats ||= Order.stats
    end
end
