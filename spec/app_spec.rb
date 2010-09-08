require File.dirname(__FILE__) + '/../app'
require 'couch_potato/rspec'

require 'spec'
require 'rack/test'

set :environment, :test

Spec::Runner.configure do |conf|
  conf.include Rack::Test::Methods
end

describe "POST /flights" do
  
  def app
    Sinatra::Application
  end
  
  before(:each) do
    @db = stub_db save: true, save!: nil
    
    @flight = stub('flight').as_null_object
    Flight.stub(new: @flight)
    
    Sinatra::Application.class_eval do
      helpers do
        def current_user
          Spec::Mocks::Mock.new('user', id: 'user-1')
        end
      end
    end
  end
  
  it "should initialzie a new flight" do
    Flight.should_receive(:new).with('number' => '123', 'date' => '2010-01-01')

    post '/flights', {flight: {number: '123', date: '2010-01-01'}}
  end
  
  it "should save the flight" do
    @db.should_receive(:save).with(@flight)
    
    post '/flights'
  end
  
  it "should initialize a ticket" do
    @flight.stub(id: 'flight-1')
    
    Ticket.should_receive(:new).with(flight_id: 'flight-1', user_id: 'user-1')
    
    post '/flights'
  end
  
  it "should save the ticket" do
    ticket = stub('ticket')
    Ticket.stub(new: ticket)
    
    @db.should_receive(:save!).with(ticket)
    
    post '/flights'
  end
  
  it "should redirect to the flight" do
    @flight.stub(to_key: 'ab1234')
    
    post '/flights'
    
    last_response.location.should == '/ab1234'
  end
end

describe "GET /:flight_key" do
  def app
    Sinatra::Application
  end
  
  it "should load the flight" do
    db = stub_db
    db.should_receive(:load).with('flight-ab123').and_return(stub.as_null_object)
    
    get '/ab123'
  end
end