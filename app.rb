require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'erb'
require 'couch_potato'
require 'twitter_oauth'
require 'ostruct'

ROOT = File.dirname(__FILE__)
$LOAD_PATH.unshift ROOT + '/lib'

configure :production do
  CouchPotato::Config.database_name = "#{ENV['CLOUDANT_URL']}/imonaplane_production"
end

configure :test do
  CouchPotato::Config.database_name = 'imonaplane_test'
end

configure :development do
  CouchPotato::Config.database_name = 'imonaplane_development'
end

AppConfig = OpenStruct.new twitter_consumer_key: ENV['TWITTER_CONSUMER_KEY'], twitter_consumer_secret: ENV['TWITTER_CONSUMER_SECRET']

require 'user'
require 'flight'
require 'ticket'


set :static, true
set :views, ROOT + '/templates'
set :public, ROOT + '/public'
set :logging, true
enable :sessions

class String
  def blank?
    size == 0
  end
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  
  def base_url
    "#{request.scheme}://#{request.host_with_port}"
  end
  
  def current_user
    @user ||= db.load session[:user_id] if session[:user_id]
  end
  
  def db
    @db ||= CouchPotato.database
  end
  
  def twitter_authorize_url
    request_token = twitter_client.request_token(oauth_callback: base_url + '/session_auth')
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    request_token.authorize_url
  end
  
  def error_on(object, attribute)
    if(error = object.errors[attribute].first)
      "<p class=\"error\">#{error}</p>"
    end
  end
  
  def twitter_client
    @twitter_client ||= TwitterOAuth::Client.new(
      consumer_key: AppConfig.twitter_consumer_key, consumer_secret: AppConfig.twitter_consumer_secret)
  end
  
  def escape_uri(uri)
    URI.escape(uri, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
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
  erb :'flights/new', locals: {flight: Flight.new}
end

post '/flights' do
  unless current_user
    redirect '/'
    return
  end
  flight = db.view(Flight.by_number_and_date([params[:flight][:number], params[:flight][:date]])).first || Flight.new(params[:flight])
  if !flight.new? || db.save(flight)
    db.save! Ticket.new(user_id: current_user.id, flight_id: flight.id, date: flight.date)
    redirect "/#{flight.to_key}"
  else
    erb :'/flights/new', locals: {flight: flight}
  end
end

get '/:flight_key' do |flight_key|
  flight = db.load Flight.to_id(flight_key)
  if flight
    erb :'flights/show', locals: {flight: flight}
  else
    404
  end
end