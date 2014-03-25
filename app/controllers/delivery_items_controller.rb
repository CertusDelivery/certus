class DeliveryItemsController < ApplicationController
  before_filter :check_barcode, only: :pick
  protect_from_forgery except: :create

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

  protected

  def check_barcode
    barcode = params[:barcode].chomp
    if DeliveryItem.specific_barcode?(barcode)
      #TODO Story#67779030
    else
      @delivery_item = DeliveryItem.in_picking_list.unpicked.find_by_store_sku(params[:barcode])
    end
    @delivery_item
  end
end
