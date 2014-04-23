module ModelInLocation

  LOCATION_REG = /^(?<aisle>\d{1,3})(?<direction>(N|S|E|W))?-( |(?<distance>\d{1,3}))?-(?<shelf>\d{1,2})?$/

  def update_location(location_info)
    begin
      location_arr = LOCATION_REG.match(location_info)
      aisle = location_arr[:aisle].to_s
      aisle = aisle.length < 3 ? '0' * (3-aisle.length) + aisle : aisle 
      direction = location_arr[:direction].to_s.upcase
      distance  = location_arr[:distance].to_i
      shelf     = location_arr[:shelf].to_i
      location_info = "#{aisle}#{direction}-#{distance == 0 ? '' : distance}-#{shelf == 0 ? '' : shelf}"
      new_location = Location.find_by_info(location_info) || 
                     Location.create_by_info(location_info)
      return false unless new_location

      self.location = new_location 
      self.save
    rescue
      false
    end
  end
end
