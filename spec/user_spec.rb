require 'couch_potato'
require File.dirname(__FILE__) + '/../lib/user'

describe User, '#login=' do
  it "should set the id" do
    User.new(login: 'langalex').id.should == 'user-langalex'
  end
end