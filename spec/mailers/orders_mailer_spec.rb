require 'spec_helper'

describe OrdersMailer do
  describe 'receipt' do
    let(:user)    { User.new(name: 'Josh Kalderimis', email: 'josh@email.com') }
    let(:address) { Address.new(city: 'Berlin') }
    let(:order)   { Order.new(user: user, package: :medium, :billing_address => address) }
    let(:email)   { OrdersMailer.confirmation(order) }

    def part(email, type)
      email.body.parts.detect { |part| part.content_type =~ /#{type}/ }.body.raw_source
    end

    %w(html text).each do |type|
      it "includes the layout" do
        part(email, type).should =~ /IRC/
      end

      it "includes the ordered package name" do
        part(email, type).should =~ /Medium/
      end

      it "includes the ordered package price" do
        part(email, type).should =~ /\$ 70/
      end

      it "includes the user's address" do
        part(email, type).should =~ /Berlin/
      end
    end

    it 'should deliver successfully' do
      email.deliver
      email = ActionMailer::Base.deliveries.last
      email.to.should == [user.email]
    end
  end
end
