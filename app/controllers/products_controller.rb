class ProductsController < ApplicationController

  protect_from_forgery except: [:update_property, :update_location]

  ## params
  #  store_sku: store SKU
  def index
    if params[:location_id]
      @products = Product.where(location_id: params[:location_id]) 
    else
      @products = Product.includes(:location).search(params[:search],params[:page])
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(params[:product].permit!)
    if @product.save()
      redirect_to :action => 'index', :search => @product.store_sku
    else
      render :new
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def update_property
    begin
      product = Product.find(params[:id])
      product[params[:property]] =  params[:value]
      product.save!
      render json: { status: true }
    rescue
      render json: { status: false, message: 'operation failure!' }
    end
  end

  def update_location
    product = Product.find(params[:id])
    status = product.update_location(params[:value])
    render json: { status: status , location: product.location }
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
