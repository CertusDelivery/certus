class DeliveryItem < ActiveRecord::Base
  # relationships .............................................................
  belongs_to :delivery
  #location rebuild
  attr_accessor :location_aisle_num, :location_direction, :location_front, :location_shelf
  after_find :location_rebuild
  # validations ...............................................................
  validates_presence_of :client_sku, :quantity, :price
  validates_numericality_of :price, greater_than: 0
  validate :order_to_delivery_convert

  # callbacks .................................................................
  before_save :update_status_if_all_picked

  # scopes ....................................................................
  scope :in_picking_list, -> { includes(:delivery).where("deliveries.picked_status = '#{Delivery::PICKED_STATUS[:picking]}'").references(:delivery) }
  scope :unpicked, -> { where(picked_status: PICKED_STATUS[:unpicked]) }

  # constants .................................................................
  PICKED_STATUS = {
    scanned:  'SCANNED',
    unpicked: 'UNPICKED',
    picked:   'PICKED'
  }
  # TODO Story#67779030
  SPECIFIC_BARCODES = {
    out_of_stock: "OUT_OF_STOCK",
    remove_completed_delivery: 'REMOVE_COMPLETED_DELIVERY'
  }

  # class methods .............................................................

  class << self
    def specific_barcode?(barcode)
      SPECIFIC_BARCODES.has_value?(barcode)
    end

    SPECIFIC_BARCODES.each do |k, v|
      define_method "#{k}?" do |barcode|
        barcode == v
      end
    end
  end

  # public instance methods ...................................................
  def pick!(quantity = 1)
    self.update_attributes({ picked_quantity: picked_quantity + quantity })
  end

  def picked?
    self.picked_status == PICKED_STATUS[:picked]
  end

  # protected instance methods ................................................
  protected

  def order_to_delivery_convert
    if client_sku != store_sku
      self.errors.add(:client_sku,"client_sku doesn't match store_sku")
    end
  end

  def update_status_if_all_picked
    self.picked_status = PICKED_STATUS[:picked] if quantity == picked_quantity
  end

  # private instance methods ..................................................
  private
  
  def location_rebuild
    begin
      reg_location = /\s*(?<aisle_num>\d{1,3})(?<direction>(n|s|e|w))?\s*-\s*(?<front>\d{1,3}*)?\s*-\s*(?<shelf>\d{1,3}*)?\s*/i
      location_arr = reg_location.match(location)
      self.location_aisle_num = location_arr[:aisle_num].to_i
      self.location_direction = location_arr[:direction].to_s.upcase
      self.location_front = location_arr[:front].to_i
      self.location_shelf = location_arr[:shelf].to_i
    rescue
    end
  end
end
