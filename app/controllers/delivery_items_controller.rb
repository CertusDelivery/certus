class DeliveryItemsController < ApplicationController
  before_filter :check_barcode, only: :pick
  protect_from_forgery except: [:pick, :substitute]

  def pick
    if @delivery_item && @delivery_item.pick!(params[:quantity] || 1)
      render 'pick'
    else
      render json: { status: 'nok', message: "You scanned the wrong item." }, status: :unprocessable_entity
    end
  end
  
  def show
    @delivery_item = DeliveryItem.find(params[:id])
  end

  def update_location
    status = delivery_item.product.update_location(params[:location])
    render json: { status: status, location: delivery_item.product.location }
  end
  
  def substitute
    original_item = DeliveryItem.find(params[:id])
    original_item.replace!
    if @delivery_item = original_item.delivery.delivery_items.find_by_client_sku(params[:product][:client_sku])
      @delivery_item.substitute_for(original_item)
    else
      @delivery_item = DeliveryItem.substitute(original_item, params[:product])
    end
    render 'show'
  end

  protected

  def check_barcode
    barcode = params[:barcode].chomp
    if DeliveryItem.specific_barcode?(barcode)
      return handle_specific_barcode(barcode)
    else
      @delivery_item = DeliveryItem.where(id: params[:id]).first
      @delivery_item = DeliveryItem.in_picking_list.unpicked.find_by_store_sku(barcode) if !@delivery_item || @delivery_item.store_sku != barcode
    end
  end

  def handle_specific_barcode(barcode)
    if DeliveryItem.out_of_stock?(barcode)
      if delivery_item.nil?
        render json: {status: 'nok', message: "Please select a product first." }, status: :unprocessable_entity 
      elsif delivery_item
        delivery_item.out_of_stock!
        render 'delivery_items/pick.json'
      end
    elsif DeliveryItem.remove_completed_delivery?(barcode)
      if delivery.nil?
        render json: {status: 'nok', message: "Please select a product first." }, status: :unprocessable_entity 
      elsif delivery.can_be_complete?
        delivery.complete!
        render json: {delivery_id: delivery.id, message: 'Delivery successfully picked.', status: "ok", remove_completed_delivery: true}
      else
        render json: {status: 'nok', message: "Please picking all products before you complete the delivery."}, status: :unprocessable_entity 
      end
    end
  end

  def delivery
    @delivery ||= (Delivery.find(params[:delivery_id]) if params[:delivery_id].present?)
  end

  def delivery_item
    @delivery_item ||= (DeliveryItem.find(params[:id]) if params[:id].present?)
  end

end
