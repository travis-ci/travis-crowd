Given /^I do not have an account$/ do
  # noop
end

# Given /^I am on the (.*) page$/ do |page|
#   visit path_for(page)
# end

Then /^I should not see the following form fields: (.*)$/ do |fields|
  fields = fields.split(',').map(&:strip)
  found = fields.select { |field| find_field(field) rescue nil }
  assert found.empty?, "Expected to not find the fields #{fields.join(', ')}, but found: #{found.join(', ')}"
end
