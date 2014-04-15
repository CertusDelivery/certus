class ProductsController < ApplicationController
  
  ## params
  #  store_sku: store SKU
  def index
    @products = Product.search(params[:search],params[:page])
    if  @products.size == 1
      @product = @products[0]
      render 'show'
    end
  end

  def show
    @product ||= Product.find(params[:id])
  end

  def search
    @product = Product.where(store_sku: params[:store_sku]).first if params[:store_sku].present?
    if @product
      render :search
    else
      render json: { status: 'nok', message: "Not Found."}, status: :not_found
    end
  end
end
