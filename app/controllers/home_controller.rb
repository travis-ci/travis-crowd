class HomeController < ApplicationController
  protected

    helper_method :results

    def results
      { users: User.users_count, companies: User.companies_count, total: Order.total }
    end
end
