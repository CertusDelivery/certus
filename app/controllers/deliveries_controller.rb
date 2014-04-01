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
      format.json { picking_delivery_items }
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
    picking_delivery_items
    render 'deliveries/picklist.json'
  end

  def remove_picked_orders
    message = Delivery.complete_all
    render json: { status: 'ok', message: message }
  end

  def sort_picking_orders
    direction = params[:direction] ==  'asc' ? 'asc' :'desc'
    @delivery_items = if direction =='asc'
        sort_picking_orders_by_location
      else
        sort_picking_orders_by_location.reverse!
    end
    render 'deliveries/picklist.json'
  end

  def picking_print
    @deliveries = Delivery.includes(:delivery_items).where({:picked_status=> Delivery::PICKED_STATUS[:store_staging]}).order("id desc")
    if params[:email].to_i == 1
     UserMailer.delivery_mail(@deliveries).deliver
    end
    render 'deliveries/picking_print', :layout => false, :locals => {:deliveries => @deliveries}
  end

  def print_packing_list
    if params[:complete].to_i == 1
      @deliveries = Delivery.includes(:delivery_items).where({:picked_status => Delivery::PICKED_STATUS[:store_staging]}).order('id desc')
    else
      @deliveries = Delivery.picking.includes(:delivery_items).select{|d| d.can_be_complete? }
    end
    render 'deliveries/print_packing_list', :layout => false
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

  def picking_delivery_items
    @delivery_items = picking_orders.map(&:delivery_items).flatten
  end

  def sort_picking_orders_by_location
    @delivery_items = picking_orders.map(&:delivery_items).flatten.sort! do |delivery_item_a, delivery_item_b|
      if delivery_item_a.location_aisle_num != delivery_item_b.location_aisle_num #location_aisle_num
        delivery_item_a.location_aisle_num <=> delivery_item_b.location_aisle_num
      elsif delivery_item_a.location_direction != delivery_item_b.location_direction #location_direction
        delivery_item_a.location_direction <=> delivery_item_b.location_direction
      elsif delivery_item_a.location_front != delivery_item_b.location_front #location_front
        delivery_item_a.location_front <=> delivery_item_b.location_front
      elsif delivery_item_a.location_shelf != delivery_item_b.location_shelf #location_shelf
        delivery_item_a.location_shelf <=> delivery_item_b.location_shelf
      else
        0
      end
    end
    @delivery_items
  end

end
