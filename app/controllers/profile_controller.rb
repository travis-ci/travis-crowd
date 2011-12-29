class ProfileController < ApplicationController
  before_filter :authenticate_user!

  protected
    helper_method :subscriptions, :payments

    def subscriptions
      current_user.subscriptions
    end

    def payments
      current_user.payments
    end
end
