class OrderMailer < ActionMailer::Base
  include ApplicationHelper
  helper_method :encoded_image

  default from: 'Travis CI <contact@travis-ci.org>'
  layout 'email'

  attr_reader :order
  helper_method :order

  def confirmation(order)
    @order = order
    mail(:to => order.user.email, :subject => 'Thank you for supporting Travis CI!')
  end
end
