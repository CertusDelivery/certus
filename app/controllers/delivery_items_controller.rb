class DeliveryItemsController < ApplicationController
  before_filter :check_barcode, only: :pick
  protect_from_forgery except: :pick

  def pick
    if @delivery_item && @delivery_item.pick!(params[:quantity] || 1)
      # TODO Story#67779306
      render json: { id: @delivery_item.id }
    else
      render json: { status: 'nok', message: "You scanned the wrong item." }, status: :unprocessable_entity 
    end
  end

  protected

  def check_barcode
    barcode = params[:barcode].chomp
    if DeliveryItem.specific_barcode?(barcode)
      return handle_specific_barcode(barcode)
    else
      @delivery_item = DeliveryItem.in_picking_list.unpicked.find_by_store_sku(barcode)
    end
  end

  def handle_specific_barcode(barcode)
    if DeliveryItem.out_of_stock?(barcode)
      #TODO Story#67779030
    elsif DeliveryItem.remove_completed_delivery?(barcode)
      if delivery.can_be_complete?
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

end
