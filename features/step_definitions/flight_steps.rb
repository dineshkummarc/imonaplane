Given /^a flight "([^"]*)" on "([^"]*)"$/ do |number, date|
  DB.save! Flight.new number: number, date: date, from: 'SFO', to: 'JFK'
end
