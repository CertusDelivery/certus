class Delivery < ActiveRecord::Base

  MAX_PICKING_COUNT = 3

  PICKED_STATUS = {
    unassigned:     'UNASSIGNED',
    unpicked:       'UNPICKED',
    picking:        'PICKING',
    picked:         'PICKED',
    store_staging:  'STORE_STAGING'
  }

  has_many :delivery_items

  scope :fifo, -> {order(id: :asc)}
  scope :unpicked, -> { where(picked_status: PICKED_STATUS[:unpicked]) }
  scope :picking, -> { where(picked_status: PICKED_STATUS[:picking]) }
  #customer
  validates_presence_of :customer_name, :shipping_address, :customer_email
  validates_format_of :customer_email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :message => 'customer email must be valid'
  #order
  validates_presence_of :order_id, :placed_at, :order_sku_count, :order_piece_count, :order_total_price
  validates_uniqueness_of :order_id, allow_nil: false
  validates_numericality_of :order_piece_count, greater_than: 0
  #payment
  validates_presence_of :payment_id, :payment_amount, :payment_card_token
  #delivery_items
  validates_associated :delivery_items
  validate :order_to_delivery_convert

  accepts_nested_attributes_for :delivery_items

  def order_to_delivery_convert
    if order_grand_total != payment_amount
      self.errors.add(:order_grand_total,"order_grand_total doesn't match payment_amount")
    end
    if order_sku_count != delivery_items.size()
      self.errors.add(:order_sku_count,"sku_count doesn't match number of order_items")
    end
    #Total Price must equal the sum of all order_item. price values
    delivery_items_total_price = 0
    delivery_items.each { |item|
      delivery_items_total_price += item.price
    }
    if order_total_price != delivery_items_total_price
      self.errors.add(:order_total_price,"total price doesn't match the sum of all order_items price")
    end
  end
end
