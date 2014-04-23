class Location < ActiveRecord::Base
  # relationship
  has_many :products
  has_many :delivery_items

  # validates
  validates_uniqueness_of :info
  validates_presence_of :aisle
  validates_inclusion_of :direction, in: %w{E W S N}, allow_blank: true
  validates_numericality_of :distance, only_integer: true, greater_than: 0, less_than: 100, :allow_blank => true
  validates_numericality_of :shelf, only_integer: true, greater_than: 0, :allow_blank => true

  LOCATION_REG = /^(?<aisle>[a-zA-Z\d]{1,2}\d)(?<direction>(N|S|E|W))?-( |(?<distance>\d{1,3}))?-(?<shelf>\d{1,2})?$/

  # scope
  default_scope { order(:aisle, :direction, :distance, :shelf) }

  # call back
  before_validation :build_info

  # class methods
  class << self
    def create_by_info(info)
      begin
        new_location = Location.new
        location_arr   = LOCATION_REG.match(info)
        new_location.aisle     = location_arr[:aisle].to_s
        new_location.direction = location_arr[:direction].to_s.upcase
        new_location.distance  = location_arr[:distance].to_i
        new_location.shelf     = location_arr[:shelf].to_i
        new_location.save!
        new_location
      rescue => e
        nil
      end
    end
  end

  # private methods
  private
  def build_info
    self.info = "#{self.aisle}#{self.direction}-#{self.distance}-#{self.shelf}"
  end
end
