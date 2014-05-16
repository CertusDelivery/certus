class Customer::OrdersController < Customer::CustomerController
    
  include Customer::OrdersHelper
  
  def show
    @order = Delivery.includes(:delivery_items => :original_item).find_by_secure_order_id(params[:id]) 
  end

  def update
    @order = Delivery.includes(:delivery_items).find_by_secure_order_id(params[:id]) 
    @order.update(order_params)
    flash[:notice] = @order.flash_notice if @order.flash_notice
    redirect_to order_secure_url(@order)
  end

  private
  def order_params
    params.require(:delivery).permit(:delivery_option, :order_flag)
  end
end
