app_file = File.join(File.dirname(__FILE__), *%w[.. .. app.rb])
require app_file
# Force the application name because polyglot breaks the auto-detection logic.
Sinatra::Application.app_file = app_file

require 'spec/expectations'
require 'rack/test'
require 'webrat'
require 'fakeweb'
require 'json'

Webrat.configure do |config|
  config.mode = :rack
end

class MyWorld
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  Webrat::Methods.delegate_to_session :response_code, :response_body

  def app
    Sinatra::Application
  end
end

World{MyWorld.new}

Before do
  DB = CouchPotato.database
  CouchPotato.couchrest_database.delete! rescue nil
  CouchPotato.couchrest_database.create!
end