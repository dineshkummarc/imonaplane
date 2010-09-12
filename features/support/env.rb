ENV['RACK_ENV'] = 'cucumber'

app_file = File.join(File.dirname(__FILE__), *%w[.. .. app.rb])
require app_file
# Force the application name because polyglot breaks the auto-detection logic.
# Sinatra::Application.app_file = app_file

require 'capybara'
require 'capybara/cucumber'
require 'spec/expectations'
require 'fakeweb'
require 'json'
require 'timecop'

DB = CouchPotato.database

Before do
  CouchPotato.couchrest_database.delete! rescue nil
  CouchPotato.couchrest_database.create!
end

Capybara.app = Sinatra::Application
Capybara.javascript_driver = :selenium
Capybara.app_host = 'http://localhost:9887'
Capybara.default_host = 'localhost'
Capybara.default_selector = :css

class MyWorld
  include Capybara
  include Spec::Expectations
  include Spec::Matchers

  # Webrat::Methods.delegate_to_session :response_code, :response_body

  def app
    Sinatra::Application
  end
end

World{MyWorld.new}
