class User
  include CouchPotato::Persistence
  
  property :twitter_access_token
  property :twitter_secret_token
  property :login
  
  view :by_id, key: :_id
  view :by_login, key: :login
  
  def login=(_login)
    super
    self._id = self.class.to_id(_login)
  end
  
  def self.to_id(login)
    "user-#{login}"
  end
end