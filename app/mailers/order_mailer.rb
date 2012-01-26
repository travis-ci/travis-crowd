class Roadie::Inliner
  # this method is incompatible with base64 encoded data image sources
  # we don't use any image urls at all, so i'll just kill this
  def make_image_urls_absolute; end
end

class OrderMailer < ActionMailer::Base
  include ApplicationHelper
  helper_method :encoded_image

  layout 'email'
  default from: 'Travis CI <contact@travis-ci.org>',
          bcc:  'Travis CI <contact@travis-ci.org>'

  attr_reader :order
  helper_method :order

  def confirmation(order)
    @order = order
    mail(:to => order.user.email, :subject => 'Thank you for supporting Travis CI!')
  end
end
