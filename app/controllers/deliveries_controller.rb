class DeliveriesController < ApplicationController
  protect_from_forgery except: :create

  def create
    begin
      @delivery = Delivery.new(params[:delivery].permit!)
      if @delivery.save
        render json: {:status => :ok, order: {order_status: 'IN_FULFILLMENT',estimated_delivery_window: @delivery.desired_delivery_window }}
      else
        render json: {:status => :nok, reason: @delivery.errors.full_messages}
      end
    rescue
      render json: {:status => :nok, reason: 'Invalid Order'}, status: 400
    end
  end

  def picklist
    @deliveries = Delivery.includes(:delivery_items).picking.limit(3)
    @unpicked_orders_count = Delivery.where(order_status: 'UNPICKED').count
  end

  def unpicked_orders
    render json: [{unpicked_count: Delivery.where(order_status: 'UNPICKED').count}]
  end
end
