class DeliveryItem < ActiveRecord::Base
  # relationships .............................................................
  belongs_to :delivery

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
  SPECIFIC_BARCODES = { out_of_stock: "888888888888888" }

  # class methods .............................................................
  def self.specific_barcode?(barcode)
    SPECIFIC_BARCODES.has_value?(barcode)
  end

  # public instance methods ...................................................
  def pick!(quantity = 1)
    self.update_attributes({ picked_quantity: picked_quantity + quantity })
  end

  def picking_progress
    [quantity, picked_quantity, out_of_stock_quantity, scanned_quantity].join('/')
  end

  # protected instance methods ................................................
  protected

  def order_to_delivery_convert
    if client_sku != store_sku
      self.errors.add(:client_sku,"order_grand_total doesn't match payment_amount")
    end
  end

  def update_status_if_all_picked
    self.picked_status = PICKED_STATUS[:picked] if quantity == picked_quantity
  end

  # private instance methods ..................................................

end
