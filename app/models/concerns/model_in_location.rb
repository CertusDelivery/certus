require 'match_data_ext'

module ModelInLocation

  def self.included(base)
    base.send :extend,  ClassMethodModule
  end

  def update_location(info)
    location_info = self.class.generate_location_info(info)
    return false unless location_info

    new_location  = Location.find_by_info(location_info) || 
                    Location.create_by_info(location_info)
    return false unless new_location

    self.location = new_location 
    self.save
  end

  module ClassMethodModule
    LOCATION_REG = /^(?<aisle>\d{1,3})(?<direction>(N|n|S|s|E|e|W|w))?-( |(?<distance>\d{1,3}))?-(?<shelf>\d{1,2})?$/

    def generate_location_hash(info)
      location_data = LOCATION_REG.match(info.strip)
      if location_data
        location_hash = location_data.to_hash
        location_hash.each do |key, value|
          location_hash[key] = value.to_i.to_s       unless key == 'direction'
          location_hash[key] = value ? value.upcase : '' if key == 'direction'
        end
      end
      location_hash
    end

    # make the location 3W-32-2 to 003W-32-2
    def generate_location_info(info)
      location_hash = generate_location_hash(info)
      if location_hash
        aisle = location_hash['aisle']
        aisle = '0' * (3-aisle.length) + aisle if aisle.length < 3
        location_hash['distance'] = '' if location_hash['distance'].to_i == 0
        location_hash['shelf']    = '' if location_hash['shelf'].to_i == 0
        location_info = "#{aisle}#{location_hash['direction']}-#{location_hash['distance']}-#{location_hash['shelf']}"
      end
      location_info
    end
  end
end
