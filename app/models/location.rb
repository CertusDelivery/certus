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
        location_hash = Product::generate_location_hash(info)
        if location_hash
          new_location           = Location.new
          new_location.aisle     = location_hash['aisle']
          new_location.direction = location_hash['direction']
          new_location.distance  = location_hash['distance'].to_i
          new_location.shelf     = location_hash['shelf'].to_i
          new_location.save!
        end
        new_location
      rescue => e
        nil
      end
    end

    def at_info(info)
      location_hash = Product.generate_location_hash(info)
      if location_hash 
        where(location_hash)
      else
        where("info = ?", info)
      end
    end
  end

  # private methods
  private
  def build_info
    self.info = Product.generate_location_info("#{self.aisle}#{self.direction}-#{self.distance}-#{self.shelf}")
  end
end
