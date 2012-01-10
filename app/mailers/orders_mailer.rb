class OrdersMailer < ActionMailer::Base
  default from: 'contact@travis-ci.org'
  layout 'email'

  attr_reader :order
  helper_method :order

  def confirmation(order)
    @order = order
    mail(:to => order.user.email, :subject => 'Thank you for supporting Travis CI!')
  end
end
