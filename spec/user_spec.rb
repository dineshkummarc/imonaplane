require 'couch_potato'
require File.dirname(__FILE__) + '/../lib/user'
require File.dirname(__FILE__) + '/../lib/ticket'
require File.dirname(__FILE__) + '/../lib/flight'
require 'timecop'
require 'couch_potato/rspec'

describe User, '#login=' do
  it "should set the id" do
    User.new(login: 'langalex').id.should == 'user-langalex'
  end
end

describe User, 'upcoming_flights' do
  it "should load the upcoming tickets" do
    Timecop.travel Date.parse('2010-01-01') do
      Ticket.should_receive(:by_user_id_and_date).with(startkey: ['user-1', '2010-01-01'], endkey: ['user-1', {}])
      
      User.new(id: 'user-1', database: stub.as_null_object).upcoming_flights
    end
  end

  it "should load the flight" do
    db = stub_db view: []
    ticket = stub('ticket', flight_id: 'flight-1')
    db.stub_view(Ticket, :by_user_id_and_date).and_return([ticket])
    
    Flight.should_receive(:by_id).with(keys: ['flight-1'])
    
    User.new(database: db).upcoming_flights
  end
end