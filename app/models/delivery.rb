class Delivery < ActiveRecord::Base

  MAX_PICKING_COUNT = 3

  ORDER_STATUS = {
    unassigned: 'UNASSIGNED',
    unpicked: 'UNPICKED',
    picking: 'PICKING',
    picked: 'PICKED'
  }

  has_many :delivery_items

  scope :fifo, -> {order(id: :asc)}
  scope :unpicked, -> { where(order_status: ORDER_STATUS[:unpicked]) }
  scope :picking, -> { where(order_status: ORDER_STATUS[:picking]) }

  validates_presence_of :shipping_address
  validates_associated :delivery_items
  #validate :order_to_delivery_convert
  accepts_nested_attributes_for :delivery_items

  def order_to_delivery_convert
    if order_grand_total != payment_amount
      self.errors.add(:order_grand_total,"order_grand_total doesn't match payment_amount")
    end
    if order_sku_count != delivery_items.size()
      self.errors.add(:order_sku_count,"sku_count doesn't match number of order_items")
    end
  end
end
