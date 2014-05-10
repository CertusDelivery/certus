class DeliveryPickerShipsController < ApplicationController
  protect_from_forgery except: [:create_by_params]
  def create_by_params
    if User.find(ship_params[:picker_id]).deliveries.picking.count < Delivery::MAX_PICKING_COUNT
      if DeliveryPickerShip.where(ship_params).size == 0
        @ship = DeliveryPickerShip.new(ship_params)
        render json: {status: @ship.save, message: 'share successfully'}
      else
        render json: {status: false, message: 'This order is already in his pickelist'}
      end
    else
      render json: {status: false, message: 'His picking amount is beyond the limit'}
    end
  end

  private
  def ship_params
    params.require(:delivery_picker_ship).permit(:delivery_id, :picker_id)
  end
end
