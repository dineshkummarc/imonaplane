Given /^a flight "([^"]*)" on "([^"]*)"$/ do |number, date|
  DB.save! Flight.new number: number, date: date, from: 'SFO', to: 'JFK'
end

Given /^a flight "([^"]*)" from "([^"]*)" to "([^"]*)"$/ do |number, from, to|
  DB.save! Flight.new number: number, date: '2010-09-10', from: from, to: to
end

