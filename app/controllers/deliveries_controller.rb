class DeliveriesController < ApplicationController
  protect_from_forgery except: :create

  def create
    begin
      #process auth, no auth, response 401(Unauthorized)
      @delivery = Delivery.new(params[:delivery].permit!)
      @delivery.picked_status = Delivery::PICKED_STATUS[:unpicked]
      if @delivery.save
        render json: {:status => :ok, order: {order_status: 'IN_FULFILLMENT',estimated_delivery_window: @delivery.desired_delivery_window }}
      else
        render json: {:status => :nok, reason: @delivery.errors.full_messages}, status: :unprocessable_entity
      end
    rescue
      render json: {:status => :nok, reason: 'Invalid Order'}, status: :bad_request
    end
  end

  def picklist
    respond_to do |format|
      format.html {}
      format.json { picking_orders }
    end
  end

  def unpicked_orders
    render text: unpicked_count
  end

  def load_unpicked_order
    # One Time One Order
    if Delivery::MAX_PICKING_COUNT > picking_count
      Delivery.fifo.unpicked.limit(1).update_all(picked_status: Delivery::PICKED_STATUS[:picking])
    end
    picking_orders
    render 'deliveries/picklist.json'
  end

  private

  def unpicked_count
    @unpicked_orders_count ||= Delivery.unpicked.count
  end

  def picking_count
    @picking_orders_count ||= Delivery.picking.count
  end

  def picking_orders
    @deliveries ||= Delivery.includes(:delivery_items).picking.limit(Delivery::MAX_PICKING_COUNT)
  end
end
