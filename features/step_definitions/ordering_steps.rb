When /^I click on "Donate" for the "([^"]*)" subscription$/ do |package|
  within("##{package}") do
    click_link('Donate')
  end
end

When /^the credit card service will create a customer for:$/ do |attrs|
  attrs = Hashr.new(attrs.rows_hash)
  attrs = { description: attrs.description, plan: attrs.plan, card: '' }
  customer = Hashr.new(id: 1)
  Stripe::Customer.expects(:create).with(attrs).returns(customer)
end

Then /^I should see a new subscription form$/ do
  page.has_css?('form#new_subscription').should be_true
end
