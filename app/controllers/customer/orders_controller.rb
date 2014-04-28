class Customer::OrdersController < ApplicationController
  layout 'customer'
  include Customer::OrdersHelper
  
  def show
    @order = Delivery.includes(:delivery_items).find_by_secure_order_id(params[:id]) 
  end

  def update
    @order = Delivery.find_by_secure_order_id(params[:id]) 
    @order.update(order_params)
    redirect_to order_secure_url(@order)
  end

  private
  def order_params
    params.require(:delivery).permit(:delivery_option, :order_flag)
  end
end
