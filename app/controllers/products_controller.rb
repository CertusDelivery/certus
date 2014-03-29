class ProductsController < ApplicationController
  
  ## params
  #  store_sku: store SKU
  def index
    @products = Product.all
  end

  def search
    @product = Product.where(store_sku: params[:store_sku]).first if params[:store_sku].present?
    if @product
      render json: @product
    else
      render json: {satus: 'nok', message: "Not Found."}, status: :not_found
    end
  end
end