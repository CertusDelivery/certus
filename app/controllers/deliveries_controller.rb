class DeliveriesController < ApplicationController

  def picklist
    @deliveries = Delivery.where(order_status: 'PICKING').limit(2)
    @unpicked_orders_count = Delivery.where(order_status: 'UNPICKED').count
  end

  def unpicked_orders
    render json: {unpicked_count: Delivery.where(order_status: 'UNPICKED').count}
  end
end
