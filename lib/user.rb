class User
  include CouchPotato::Persistence
  
  property :twitter_access_token
  property :twitter_secret_token
  property :login
  
  def login=(_login)
    super
    self._id = "user-#{_login}"
  end
end