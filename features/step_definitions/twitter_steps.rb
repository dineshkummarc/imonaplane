Given /^twitter is set up$/ do
  FakeWeb.register_uri :post, 'http://twitter.com/oauth/request_token', 
                        body: 'oauth_token=123&oauth_token_secret=456'
end

When /^the twitter oauth goes through for "([^\"]+)"$/ do |twitter_name|
  FakeWeb.register_uri :post, 'http://twitter.com/oauth/access_token',
                        body: 'oauth_token=123&oauth_token_secret=456'
  FakeWeb.register_uri :get, 'http://twitter.com/account/verify_credentials.json',
                        status: ['200', 'OK'],
                        body: {profile_image_url: 'http://img.twitter.com/def.png', screen_name: twitter_name}.to_json
                        
  get '/session_auth', oauth_verifier: '789'
  follow_redirect!
end