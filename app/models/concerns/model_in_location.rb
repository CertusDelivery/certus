module ModelInLocation
  def update_location(location_info)
    new_location = Location.find_by_info(location_info) || 
                   Location.create_by_info(location_info)
    return false unless new_location

    self.location = new_location 
    self.save
  end
end
