class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!, :only => :show
  before_filter :normalize_params,   :only => [:new, :create]

  def create
    if user.valid? && subscription.valid?
      user.save
      subscription.save_with_payment!
      sign_in user
      redirect_to subscription, notice: "Thank you for your support!"
    else
      render :new
    end
  end

  protected

    helper_method :user, :subscription, :billing_address, :shipping_address
    delegate :billing_address, :shipping_address, to: :subscription

    def user
      @user ||= current_user || User.new(params[:user])
    end

    def subscription
      @subscription ||= if params[:action].to_sym == :show
        user.subscriptions.find(params[:id])
      else
        user.subscriptions.build(params[:subscription])
      end
    end

    def normalize_params
      params[:subscription] ||= { plan_id: params[:plan] || 'tiny' }
      params[:subscription][:billing_address_attributes] ||= { name: user.name }
      params[:subscription][:billing_address_attributes][:kind] = :billing
      params[:subscription][:shipping_address_attributes] ||= { name: user.name }
      params[:subscription][:shipping_address_attributes][:kind] = :shipping
    end
end
