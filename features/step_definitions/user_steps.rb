Given /^a user with the login "([^"]*)"$/ do |login|
  DB.save! User.new login: login
end

Given /^a user "([^"]*)" is signed in$/ do |login|
  Given %Q{twitter is set up for "#{login}"}
  And %Q{a user with the login "#{login}"}
  When 'I go to the start page'
  And 'I follow "Sign in with Twitter"'
end
