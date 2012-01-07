When /^I click on "Donate" for the "([^"]*)" subscription$/ do |package|
  within("##{package}") do
    click_link('Donate')
  end
end

When /^the credit card service returns the credit card token "(.*)"/ do |token|
  # page.execute_script('$("#user_stripe_card_token").val(token);')
  #
  # Big hack around the fact that we can't set form fields from js in cucumber/rack
  # The order creation form will first post to Stripe through js and fetch a token.
  # It will then set this token to a new field stripe_card_token before it then
  # actually submits the form. We fake adding this parameter here.
  #
  Cucumber::FakeParameterMiddleware.params = { 'user' => { 'stripe_card_token' => token } }
end

When /^the credit card service will create a customer for:$/ do |attrs|
  attrs = attrs.rows_hash.symbolize_keys
  attrs[:plan] ||= nil
  @customer = Hashr.new(id: 1)
  Stripe::Customer.expects(:create).with(attrs).returns(@customer)
end

When /^the credit card service will not create a customer$/ do
  Stripe::Customer.expects(:create).never
end

When /^the credit card service will create the following charge:$/ do |attrs|
  attrs = attrs.rows_hash.symbolize_keys
  attrs[:amount] = attrs[:amount].to_i
  charge = Hashr.new(id: 1)
  Stripe::Charge.expects(:create).with(attrs).returns(charge)
end

Then /^I should see a new subscription form$/ do
  page.has_css?('form#new_subscription').should be_true
end


