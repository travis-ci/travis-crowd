Given /^I have the following account:$/ do |data|
  User.create(data.rows_hash.to_hash)
end

When /^I sign in as "(.*)" using (.*)$/ do |name, provider|
  OmniAuth.config.mock_auth[:twitter] = oauth_payload_for(provider, name)
  visit '/users/auth/twitter'
end
