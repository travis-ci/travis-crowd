When /^I click on "Donate" for the "([^"]*)" subscription$/ do |package|
  within("##{package}") do
    click_link('Donate')
  end
end

Then /^I should see a new subscription form$/ do
  page.has_css?('form#new_subscription').should be_true
end
