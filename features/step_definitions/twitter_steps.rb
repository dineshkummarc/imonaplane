Given /^twitter is set up for "([^\"]+)"$/ do |login|
  $current_user_login = login
  TwitterOAuth::Client.class_eval do
    def self.new(*args)
      client = Object.new
    
      def client.request_token(*arg)
        token = Object.new
        def token.token(*args); nil; end
        def token.secret(*args); nil; end
        def token.authorize_url(*args)
          '/session_auth?oauth_verifier=789'
        end
        token
      end
    
      def client.authorized?
        true
      end
    
      def client.info
        {'screen_name' => $current_user_login}
      end
    
      def client.authorize(*arg)
        token = Object.new
        def token.token(*args); nil; end
        def token.secret(*args); nil; end
        token
      end
      client
    end
  end
end
