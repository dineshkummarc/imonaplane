Given /^"([^"]*)" in on flight "([^"]*)" on "([^"]*)"$/ do |login, flight_number, flight_date|
  flight = DB.view(Flight.by_number_and_date([flight_number, flight_date])).first
  user = DB.view(User.by_login(login)).first
  DB.save! Ticket.new user_id: user.id, flight_id: flight.id
end
