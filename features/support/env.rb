require 'rubygems'
require 'capybara/cucumber'
require File.dirname(__FILE__) + '/../app'

require 'test/unit'
require 'test/unit/assertions'
include Test::Unit::Assertions

Capybara.app = Sinatra::Application
Capybara.javascript_driver = :selenium
#Capybara.default_driver = :selenium
