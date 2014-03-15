class Delivery < ActiveRecord::Base
  has_many :delivery_items

  validates_presence_of :shipping_address
  validates_associated :delivery_items
  validate :order_to_delivery_convert


  def order_to_delivery_convert
    if order_grand_total != payment_amount
      self.errors.add(:order_grand_total,"order_grand_total doesn't match payment_amount")
    end
    if order_sku_count != delivery_items.size()
      self.errors.add(:order_sku_count,"sku_count doesn't match number of order_items")
    end
  end
end
