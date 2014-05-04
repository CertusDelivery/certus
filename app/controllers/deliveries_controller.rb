class DeliveriesController < ApplicationController
  protect_from_forgery except: :create

  def create
    begin
      #process auth, no auth, response 401(Unauthorized)
      @delivery = Delivery.new(delivery_params)
      if @delivery.save
        UserMailer.customer_notification(@delivery).deliver
        render json: {:status => :ok, order: {order_status: 'IN_FULFILLMENT',estimated_delivery_window: @delivery.desired_delivery_window }}
      else
        render json: {:status => :nok, reason: @delivery.errors.full_messages}, status: :unprocessable_entity
      end
    rescue => e
      render json: {:status => :nok, reason: "Invalid Order. #{e.inspect}"}, status: :bad_request
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
    @deliveries = Delivery.picking.includes(:delivery_items).select{|d| d.can_be_complete? }
    if params[:email].to_i == 1
      UserMailer.delivery_mail(@deliveries).deliver
    end
    render 'deliveries/picking_print', :layout => false, :locals => {:deliveries => @deliveries}
  end

  def print_packing_list
    @deliveries = Delivery.includes(:delivery_items).where(:id => params[:id]) if params[:id]
    if params[:complete].to_i == 1
      @deliveries ||= Delivery.includes(:delivery_items).where({:picked_status => Delivery::PICKED_STATUS[:store_staging]}).order('id desc')
    else
      @deliveries ||= Delivery.picking.includes(:delivery_items).select{|d| d.can_be_complete? }
    end
    render 'deliveries/print_packing_list', :layout => false
  end

  def history
    # ids = DeliveryItem.where('picked_quantity != 0').pluck(:delivery_id)
    # @deliveries = Delivery.where(:id => ids)
    @deliveries = Delivery.includes(:delivery_items).where('id in (select delivery_id from delivery_items where picked_quantity != 0)').page(params[:page]).order('placed_at desc')
  end

  private

  def unpicked_count
    @unpicked_orders_count ||= Delivery.unpicked.count
  end

  def picking_count
    @picking_orders_count ||= Delivery.picking.count
  end

  def picking_orders
    @deliveries ||= Delivery.includes(:delivery_items => {:product => :location}).picking.limit(Delivery::MAX_PICKING_COUNT)
  end

  def picking_delivery_items
    @delivery_items = picking_orders.map(&:delivery_items).flatten
  end

  def sort_picking_orders_by_location
    @delivery_items = picking_orders.map(&:delivery_items).flatten.sort! do |delivery_item_a, delivery_item_b|
      location_a = delivery_item_a.product.try(:location) || Location.new(aisle:'',direction:'',distance:0,shelf:0)
      location_b = delivery_item_b.product.try(:location) || Location.new(aisle:'',direction:'',distance:0,shelf:0)
      if location_a.aisle != location_b.aisle #location_aisle
        location_a.aisle <=> location_b.aisle
      elsif location_a.direction != location_b.direction #location_direction
        location_a.direction <=> location_b.direction
      elsif location_a.distance != location_b.distance #location_distance
        location_a.distance <=> location_b.distance
      elsif location_a.shelf != location_b.shelf #location_shelf
        location_a.shelf <=> location_b.shelf
      else
        0
      end
    end
    @delivery_items
  end

  def delivery_params
    params.require(:delivery).permit(:customer_name, :delivery_option, :order_flag, :shipping_address, :customer_email, :order_id, :client_id, :order_piece_count, :payment_id, :payment_card_token, :order_status, :picked_status, :order_grand_total, :payment_amount, :order_sku_count, :order_total_price, :placed_at, delivery_items_attributes: [:picked_status, :product_name, :quantity, :shipping_weight, :shipping_weight_unit, :picked_quantity, :picker_bin_number, :store_sku, :client_sku, :price, :order_item_options_flags])
  end
end
