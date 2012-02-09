class OrdersController < ApplicationController
  before_filter :authenticate_user!, only: [:show, :destroy]
  before_filter :normalize_params,   only: [:new, :create]
  before_filter :guard_duplicate_subscription, only: [:new, :create]
  before_filter :validate_logged_in, only: [:confirm]

  def index
    render json: Order.includes(:user).order('created_at DESC').as_json
  end

  def stats
    render json: Order.stats
  end

  def show
    render :confirm_creation
  end

  def create
    if user.valid? && order.valid?
      begin
        user.save_with_customer!
        sign_in user
        order.save_with_payment!
      rescue Stripe::CardError => e
        order.errors.add(:base, "There was an error charging your credit card: #{e.message}")
        report(e)
        return render :new
      end
      send_confirmation
      redirect_to confirm_order_url(order)
    else
      render :new
    end
  end

  def confirm
    render :confirm_creation
  end

  def destroy
    order.cancel!
    redirect_to profile_url
  end

  protected

    helper_method :user, :order, :billing_address, :shipping_address, :subscription?, :company?, :needs_vat?
    delegate :billing_address, :shipping_address, to: :order

    def send_confirmation
      OrderMailer.confirmation(order).deliver
    end

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

    def needs_vat?
      company? or params[:package] == 'huge' or
      params[:package] == 'big' && !subscription?
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

    def validate_logged_in
      redirect_to root_url if current_user.nil?
    end

    def report(boom)
      Hubble.report(boom, {
        :method       => request.request_method,
        :user_agent   => env['HTTP_USER_AGENT'],
        :params       => (request.params.inspect rescue nil),
        :session      => (request.session.inspect rescue nil),
        :referrer     => request.referrer,
        :remote_ip    => request.ip,
        :url          => request.url
      })
    end
end
