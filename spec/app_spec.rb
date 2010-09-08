require 'spec_helper'
require File.dirname(__FILE__) + '/../app'

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
    @db = stub_db save: true, save!: nil, view: []
    
    Sinatra::Application.class_eval do
      helpers do
        def current_user
          Spec::Mocks::Mock.new('user', id: 'user-1')
        end
      end
    end
  end
  
  it "should redirect to the start page if not logged in" do
    Sinatra::Application.class_eval do
      helpers do
        def current_user
          nil
        end
      end
    end
    
    post '/flights'
    
    last_response.status.should == 302
    last_response.location.should == '/'
  end

  context 'flight exists already' do
    before(:each) do
      @flight = stub('flight').as_null_object
      @db.stub_view(Flight, :by_number_and_date).with(['123', '2010-01-01']).and_return(@flight)
    end
    
    it "should initialize a ticket" do
      @flight.stub(id: 'flight-1', date: '2010-01-01')

      Ticket.should_receive(:new).with(flight_id: 'flight-1', user_id: 'user-1', date: '2010-01-01')

      post '/flights', flight: {number: '123', date: '2010-01-01'}
    end
    
    it "should save the ticket" do
      ticket = stub('ticket')
      Ticket.stub(new: ticket)

      @db.should_receive(:save!).with(ticket)

      post '/flights', flight: {number: '123', date: '2010-01-01'}
    end

    it "should redirect to the flight" do
      @flight.stub(to_key: 'ab1234')

      post '/flights', flight: {number: '123', date: '2010-01-01'}

      last_response.location.should == '/ab1234'
    end
    
    
  end
  
  context 'no flight exists' do
    before(:each) do
      @db.stub_view(Flight, :by_number_and_date).with(['123', '2010-01-01']).and_return([])
      @flight = stub('flight').as_null_object
      Flight.stub(new: @flight)
    end
    
    it "should initialize a new flight" do
      Flight.should_receive(:new).with('number' => '123', 'date' => '2010-01-01')

      post '/flights', flight: {number: '123', date: '2010-01-01'}
    end
  
    it "should save the flight" do
      @db.should_receive(:save).with(@flight)
    
      post '/flights', flight: {number: '123', date: '2010-01-01'}
    end
    
    it "should initialize a ticket" do
      @flight.stub(id: 'flight-1', date: '2010-01-01')

      Ticket.should_receive(:new).with(flight_id: 'flight-1', user_id: 'user-1', date: '2010-01-01')

      post '/flights', flight: {number: '123', date: '2010-01-01'}
    end
    
    it "should save the ticket" do
      ticket = stub('ticket')
      Ticket.stub(new: ticket)

      @db.should_receive(:save!).with(ticket)

      post '/flights', flight: {number: '123', date: '2010-01-01'}
    end

    it "should redirect to the flight" do
      @flight.stub(to_key: 'ab1234')

      post '/flights', flight: {number: '123', date: '2010-01-01'}

      last_response.location.should == '/ab1234'
    end
    
  end

  context 'saving the flight fails' do
    before(:each) do
      @db.stub(:save).and_return(false)
    end
    
    it "should not create a ticket" do
      Ticket.should_not_receive(:new)
      
      post '/flights', flight: {number: '123', date: '2010-01-01'}
    end
    
    it "should render new flight" do
      post '/flights', flight: {number: '123', date: '2010-01-01'}
      
      last_response.should be_ok
    end
    
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
  
  it "should return 200" do
    db = stub_db
    db.stub(:load).and_return(stub.as_null_object)
    
    get '/ab123'
    last_response.status.should == 200
  end
  
  it "should return 404 if no flight was found" do
    db = stub_db
    db.stub(:load).and_return(nil)
    
    get '/ab123'
    last_response.status.should == 404
    
  end
end