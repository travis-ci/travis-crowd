class OrdersMailer < ActionMailer::Base
  default from: 'Travis CI <contact@travis-ci.org>'
  layout 'email'

  attr_reader :order
  helper_method :order

  def confirmation(order)
    @order = order
    attach_images(%w(travis-ci.png footer.png))
    mail(:to => order.user.email, :subject => 'Thank you for supporting Travis CI!')
  end

  protected

    def attach_images(images)
      images.each do |name|
        attachments.inline[name] = File.read(Rails.root.join("public/images/#{name}"))
      end
    end
end
