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

  # call back
  before_validation :build_info

  # private methods
  private
  def build_info
    self.info = "#{self.aisle}#{self.direction}-#{self.distance}-#{self.shelf}"
  end
end
