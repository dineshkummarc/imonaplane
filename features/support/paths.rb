module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /start page/
      "/"
    when /the page for flight "(\w+)"/
      flight_no = $1
      flight = DB.view(Flight.by_number(flight_no)).first
      "/#{flight.to_key}"
    else
      raise "Can't find mapping from \"#{page_name}\" to a path."
    end
  end
end

World(NavigationHelpers)