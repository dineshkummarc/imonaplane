require 'rubygems'
require 'sinatra'

ROOT = File.dirname(__FILE__) + '/..'
set :static, true
set :public, ROOT + '/public'
set :logging, true


get '/' do
  'Hello world!'
end