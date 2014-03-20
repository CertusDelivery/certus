class DeliveryItem < ActiveRecord::Base
  belongs_to :delivery

  validates_presence_of :client_sku, :quantity, :price
  validates_numericality_of :price, greater_than: 0
  validate :order_to_delivery_convert


  def order_to_delivery_convert
    if client_sku != store_sku
      self.errors.add(:client_sku,"order_grand_total doesn't match payment_amount")
    end
  end
end
