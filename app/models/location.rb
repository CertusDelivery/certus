class Location < ActiveRecord::Base
  # relationship
  has_many :products
  has_many :delivery_items

  # validates
  validates_uniqueness_of :info
  validates_presence_of :aisle
  validates_inclusion_of :direction, in: %w{E W S N}, allow_blank: true
  validates_numericality_of :distance, only_integer: true, less_than: 1000, :allow_blank => true
  validates_numericality_of :shelf, only_integer: true, :allow_blank => true

  # scope
  default_scope { order(:aisle, :direction, :distance, :shelf) }

  # call back
  before_validation :build_info

  # class methods
  class << self
    def create_by_info(info)
      begin
        new_location = Location.new
        location_arr   = Product::LOCATION_REG.match(info)
        new_location.aisle     = location_arr[:aisle].to_i.to_s
        return nil if new_location.aisle.to_i == 0
        new_location.direction = location_arr[:direction].to_s.upcase
        new_location.distance  = location_arr[:distance].to_i
        new_location.shelf     = location_arr[:shelf].to_i
        new_location.save!
        new_location
      rescue => e
        nil
      end
    end

    def at_info(info)
      location_arr   = Product::LOCATION_REG.match(info)
      if  location_arr
        location_arr = Hash[location_arr.names.zip(location_arr.captures)]
        location_arr['distance'] = 0 if location_arr['distance'].blank? 
        location_arr['shelf'] = 0 if location_arr['shelf'].blank? 
        where(location_arr)
      else
        includes(:products).paginate(per_page: 15, page: 1)
      end
    end
  end

  # private methods
  private
  def build_info
    aisle = self.aisle.length < 3 ? '0' * (3-self.aisle.length) + self.aisle : self.aisle 
    self.info = "#{aisle}#{self.direction}-#{self.distance == 0 ? '' : self.distance}-#{self.shelf == 0 ? '' : self.shelf}"
  end
end
