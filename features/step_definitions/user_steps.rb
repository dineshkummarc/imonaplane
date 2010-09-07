Given /^a user with the login "([^"]*)"$/ do |login|
  DB.save! User.new login: login
end
