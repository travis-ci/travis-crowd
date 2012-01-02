Given /^I have the following account:$/ do |data|
  User.create(data.rows_hash.to_hash)
end

Given /^I am signed in as "(.*)" and I have the stripe customer id "(.*)"$/ do |email, stripe_customer_id|
  user = User.create!(name: email.split('@').first.titleize, email: email, password: 'password', stripe_customer_id: stripe_customer_id)
  visit '/users/sign_in'
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: 'password'
  click_button 'Sign in'
end

When /^I sign in as "(.*)" using (.*)$/ do |name, provider|
  OmniAuth.config.mock_auth[:twitter] = oauth_payload_for(provider, name)
  visit '/users/auth/twitter'
end
