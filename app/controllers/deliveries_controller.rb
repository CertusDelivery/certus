class DeliveriesController < ApplicationController
  protect_from_forgery except: :create

  def create
    begin
      @delivery = Delivery.new(params[:delivery].permit!)
      if @delivery.save
        render json: {:status => :true, message: ''}
      else
        render json: {:status => :false, message: @delivery.errors.full_messages}
      end
    rescue
      render json: {:status => :false, message: 'Invalid Order'}, status: 400
    end
  end

  def picklist
    @deliveries = Delivery.includes(:delivery_items).where(order_status: 'PICKING').limit(3)
    @unpicked_orders_count = Delivery.where(order_status: 'UNPICKED').count
  end

  def unpicked_orders
    render json: {unpicked_count: Delivery.where(order_status: 'UNPICKED').count}
  end
end
