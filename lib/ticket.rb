class Ticket
  include CouchPotato::Persistence
  
  property :flight_id
  property :user_id
  property :date
  
  validates_presence_of :flight_id, :user_id, :date
  
  view :by_flight_id, key: :flight_id
  view :by_user_id_and_date, key: [:user_id, :date]
end