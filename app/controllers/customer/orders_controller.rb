class Customer::OrdersController < ApplicationController
  layout 'customer'
  
  def show
    @order = Delivery.search_by_secure_code(params[:id]) 
  end
end
