require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'erb'
require 'couch_potato'
require 'twitter_oauth'
require 'ostruct'

ROOT = File.dirname(__FILE__)
BASE_URL = 'http://imonaplane.net'
$LOAD_PATH.unshift ROOT + '/lib'

CouchPotato::Config.database_name = 'imonaplane_test'

require 'user'
require 'flight'
require 'ticket'

if ENV['TWITTER_CONSUMER_KEY'].nil? || ENV['TWITTER_CONSUMER_SECRET'].nil?
  STDERR.puts "Must specify TWITTER_CONSUMER_SECRET and TWITTER_CONSUMER_KEY in env"
  exit -1
end
AppConfig = OpenStruct.new twitter_consumer_key: ENV['TWITTER_CONSUMER_KEY'], twitter_consumer_secret: ENV['TWITTER_CONSUMER_SECRET']

set :static, true
set :views, ROOT + '/templates'
set :public, ROOT + '/public'
set :logging, true
enable :sessions

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  
  def current_user
    @user ||= db.load session[:user_id] if session[:user_id]
  end
  
  def db
    @db ||= CouchPotato.database
  end
  
  def twitter_authorize_url
    request_token = twitter_client.request_token(oauth_callback: BASE_URL + '/session_auth')
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    request_token.authorize_url
  end
  
  def twitter_client
    @twitter_client ||= TwitterOAuth::Client.new(
      consumer_key: AppConfig.twitter_consumer_key, consumer_secret: AppConfig.twitter_consumer_secret)
  end
end

get '/' do
  erb :index
end

get '/session/new' do
  redirect twitter_authorize_url
end

get '/session_auth' do
  if params[:oauth_verifier]
    access_token = twitter_client.authorize(
      session[:request_token], session[:request_token_secret], oauth_verifier: params[:oauth_verifier])
    if twitter_client.authorized?
      user = db.load(User.to_id(twitter_client.info['screen_name'])) || User.new(login: twitter_client.info['screen_name'], twitter_access_token: access_token.token,
        twitter_secret_token: access_token.secret)
      db.save! user
      session[:user_id] = user.id
    end
  end
  redirect '/'
end

get '/flights/new' do
  erb :'flights/new'
end

post '/flights' do
  flight = Flight.new params[:flight]
  db.save flight
  db.save! Ticket.new(user_id: current_user.id, flight_id: flight.id)
  redirect "/#{flight.to_key}"
end

get '/:flight_key' do |flight_key|
  flight = db.load Flight.to_id(flight_key)
  erb :'flights/show', locals: {flight: flight}
end