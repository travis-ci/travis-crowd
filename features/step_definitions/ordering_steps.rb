When /^I click on "Donate" for the "([^"]*)" subscription$/ do |package|
  within("##{package}") do
    click_link('Donate')
  end
end

When /^the credit card service returns a credit card token/ do
  # page.execute_script('$("#order_stripe_card_token").val("12345678");')
  @set_strip_card_token ||= OrdersController.before_filter(only: :create) do
    params[:order][:stripe_card_token] = '12345678'
  end
end

When /^the credit card service will create a customer for:$/ do |attrs|
  attrs = attrs.rows_hash.symbolize_keys
  @customer = Hashr.new(id: 1)
  Stripe::Customer.expects(:create).with(attrs).returns(@customer)
end

When /^the credit card service will create the following charge:$/ do |attrs|
  attrs = attrs.rows_hash.symbolize_keys
  attrs[:amount] = attrs[:amount].to_i
  attrs[:customer] = attrs[:customer].to_i
  charge = Hashr.new(id: 1)
  Stripe::Charge.expects(:create).with(attrs).returns(charge)
end

Then /^I should see a new subscription form$/ do
  page.has_css?('form#new_subscription').should be_true
end


