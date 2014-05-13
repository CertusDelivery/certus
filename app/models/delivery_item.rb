class DeliveryItem < ActiveRecord::Base

  # relationships .............................................................
  belongs_to :delivery
  belongs_to :original_item, class_name: 'DeliveryItem', foreign_key: 'original_item_id'
  has_one :substituted_item, class_name: 'DeliveryItem', foreign_key: 'original_item_id'
  belongs_to :product, primary_key: 'store_sku', foreign_key: 'store_sku'

  # validations ...............................................................
  validates_presence_of :client_sku, :quantity, :price
  validates_numericality_of :price, greater_than: 0
  #TODO
  #validate :order_to_delivery_convert

  # callbacks .................................................................
  before_create :initial_picked_status, :update_status_if_all_picked #,:init_random_location_for_test
  before_save :update_status_if_all_picked
  after_update :publish_item_for_faye
  # TODO
  # before_save :calculate_amount
  LOCATION_REG = /^(?<aisle_num>\d{1,3})(?<direction>(N|S|E|W))?-( |(?<front>\d{1,3}))?-(?<shelf>\d{1,2})?$/
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

    def substitute(original_item, product_params)
      item_params = product_params.merge({quantity: original_item.out_of_stock_quantity, delivery_id: original_item.delivery_id, picked_quantity: 1, picker_bin_number: original_item.picker_bin_number, original_item_id: original_item.id})
      self.create(item_params.permit!)
    end
  end

  # public instance methods ...................................................
  def pick!(quantity = 1)
    return false if (quantity + self.picked_quantity + self.out_of_stock_quantity > self.quantity)
    self.update_attributes({ picked_quantity: picked_quantity + quantity })
  end

  def picking_progress
    [quantity, picked_quantity, out_of_stock_quantity].join('/')
  end

  def picked?
    self.picked_status == PICKED_STATUS[:picked]
  end

  def out_of_stock!
    out_of_stock = quantity - picked_quantity
    self.update_attributes(out_of_stock_quantity: out_of_stock)
    self.product.out_of_stock! if self.product
  end

  # For Test
  def product_image
    "/products/#{['len', 'piggy', 'battery'][self.id%3]}.jpg"
  end

  alias :update_out_of_stock_quantity :out_of_stock!

  def replace!
    self.update_attributes({ is_replaced: true })
  end

  def substitute_for(other)
    self.update_attributes({ quantity: quantity + other.out_of_stock_quantity, picked_status: PICKED_STATUS[:unpicked], original_item_id: other.id })
    self.pick!
  end

  def total_price
    self.quantity * self.price
  end

  def picked_total_price
    self.picked_quantity * self.price
  end


  # protected instance methods ................................................
  protected

  def publish_item_for_faye
    client = Faye::Client.new(Setting.faye_server)
    client.publish('/delivery_items/updated', self)
  end

  def order_to_delivery_convert
    if client_sku != store_sku
      self.errors.add(:client_sku,"client_sku doesn't match store_sku")
    end
  end

  def initial_picked_status
    self.picked_status = PICKED_STATUS[:unpicked]
  end

  def update_status_if_all_picked
    self.picked_status = PICKED_STATUS[:picked] if self.quantity == (self.picked_quantity + self.out_of_stock_quantity)
  end

  def init_random_location_for_test
    unless self.location
      aisle_num = %w{01 12 03 04}.sample
      direction = ["N", "S", "E", "W", ""].sample
      front     = %w{10 20 66 90}.sample
      shelf     = %w{1 2 3 4 5 6 7 8 9}.sample
      
      self.location= Location.create_by_info("#{aisle_num}#{direction}-#{front}-#{shelf}")
    end
  end

  # FIXME
  def calculate_amount
    self.order_item_amount = (price + tax) * (quantity - out_of_stock_quantity) + other_adjustments
  end

  # private instance methods ..................................................
end
