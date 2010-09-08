class Ticket
  include CouchPotato::Persistence
  
  property :flight_id
  property :user_id
  
  validates_presence_of :flight_id, :user_id
  
  view :by_flight_id, key: :flight_id
end