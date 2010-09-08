require 'spec_helper'
require File.dirname(__FILE__) + '/../lib/flight'
require File.dirname(__FILE__) + '/../lib/ticket'
require File.dirname(__FILE__) + '/../lib/user'

describe Flight, 'number=' do
  it "should remove spaces" do
    Flight.new(number: '3 310').number.should == '3310'
  end
  
  it "should upcase everything" do
    Flight.new(number: 'el310').number.should == 'EL310'
  end
end

describe Flight, 'setting the flight no and date' do
  it "should set the id" do
    Flight.new(number: 'AB123', date: '2010-01-01').id.should == 'flight-2010-01-01-AB123'
  end
end

describe Flight, '#to_key' do
  it "should return the flight number and date" do
    Flight.new(number: 'AB123', date: '2010-01-01').to_key.should == '2010-01-01-AB123'
  end
end

describe Flight, 'passengers' do
  it "should load the tickets" do
    db = stub 'db', view: []
    tickets_view = stub('tickets_view')
    
    Ticket.stub(:by_flight_id).with('flight-1').and_return(tickets_view)
    db.should_receive(:view).with(tickets_view).and_return([])
    
    Flight.new(database: db, id: 'flight-1').passengers
  end
  
  it "should load the users" do
    ticket = stub 'ticket', user_id: 'user-1'
    db = stub 'db', view: [ticket]
    users_view = stub('users_view')
    
    User.stub(:by_id).with(keys: ['user-1']).and_return(users_view)
    db.should_receive(:view).with(users_view)
    
    flight = Flight.new database: db, id: 'flight-1'
    flight.passengers
  end
end