class Flight
  include CouchPotato::Persistence
  
  property :number
  property :date
  
  view :by_number, key: :number
  
  validates_presence_of :number
  validates_format_of :date, :with => /^\d{4}-\d{2}-\d{2}$/, message: /let's keep this in the YYYY-MM-DD format please/
  
  def number=(_number)
    super
    set_id
  end
  
  def date=(_date)
    super
    set_id
  end
  
  def to_key
    id.to_s[7..-1]
  end
  
  def self.to_id(key)
    "flight-#{key}"
  end
  
  def passengers
    tickets = database.view(Ticket.by_flight_id(id))
    database.view(User.by_id(keys: tickets.map(&:user_id)))
  end
  
  private
  
  def set_id
    if number && date
      self.id = "flight-#{date}-#{number}"
    end
  end
end