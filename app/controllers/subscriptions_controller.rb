class SubscriptionsController < ApplicationController
  before_filter :normalize_params
  before_filter :update_user

  def new
    session["user_return_to"] = "#{request.path}?#{request.query_string}"
  end

  def create
    if current_user.valid? && subscription.valid?
      current_user.save
      subscription.save # _with_payment
      redirect_to subscription, :notice => "Thank you for subscribing!"
    else
      render :new
    end
  end

  protected

    helper_method :current_user, :subscription, :billing_address, :shipping_address
    delegate :billing_address, :shipping_address, :to => :subscription

    def current_user
      @current_user ||= super || User.new
    end

    def subscription
      @subscription ||= if params[:action].to_sym == :show
        current_user.subscriptions.find(params[:id])
      else
        current_user.subscriptions.build(params[:subscription].except(:user_attributes))
      end
    end

    def update_user
      params[:subscription][:user_attributes].each do |name, value|
        current_user.send(:"#{name}=", value)
      end if params.key?(:subscription)
    end

    def normalize_params
      params[:subscription] ||= {
        :plan => params[:plan] || 'tiny',
        :user_attributes => {},
        :billing_address_attributes => { :name => current_user.name },
        :shipping_address_attributes => { :name => current_user.name }
      }
    end
end
