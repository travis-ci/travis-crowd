class OrdersController < ApplicationController
  before_filter :authenticate_user!, only: [:show, :destroy]
  before_filter :normalize_params,   only: [:new, :create]
  before_filter :guard_duplicate_subscription, only: [:new, :create]

  def index
    render json: Order.all.as_json
  end

  def show
    render :confirm_creation
  end

  def create
    if user.valid? && order.valid?
      user.save_with_customer!
      order.save_with_payment!
      sign_in user
      # redirect_to order, notice: "Thank you for your support!"
      render :confirm_creation
    else
      # p user.errors, order.errors
      render :new
    end
  end

  def destroy
    order.cancel!
    redirect_to profile_url
  end

  protected

    helper_method :user, :order, :billing_address, :shipping_address, :subscription?, :company?
    delegate :billing_address, :shipping_address, to: :order

    def user
      @user ||= current_user || User.new(params[:user])
    end

    def order
      @order ||= params[:id] ? user.orders.find(params[:id]) : user.orders.build(params[:order])
    end

    def subscription?
      !!params[:subscription]
    end

    def company?
      %w(silver gold platinum).include?(params[:package])
    end

    def subscribed?
      signed_in? && current_user.subscriptions.active.any?
    end

    def normalize_params
      params[:order] ||= { package: params[:package] || 'tiny', subscription: subscription? }
      params[:user]  ||= {}
      params[:user][:company] = company?
      [:billing, :shipping].each { |kind| normalize_address_params(kind) }
    end

    def normalize_address_params(kind)
      params[:order][:"#{kind}_address_attributes"] ||= { name: user.name }
      params[:order][:"#{kind}_address_attributes"][:kind] = kind
    end

    def guard_duplicate_subscription
      render :duplicate_subscription if subscription? && subscribed?
    end
end
