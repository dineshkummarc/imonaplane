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
  
  def upcoming_flights
    tickets = database.view(Ticket.by_user_id_and_date(startkey: [id, Date.today.to_s], endkey: [id, {}]))
    database.view(Flight.by_id(keys: tickets.map(&:flight_id)))
  end
  
  def self.to_id(login)
    "user-#{login}"
  end
end