class ProductsController < ApplicationController

  protect_from_forgery except: [:update_property, :update_location, :create_at_location]

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
    @product.store_sku = params[:store_sku]
  end

  def create
    @product = Product.new(product_params)
    if @product.errors.blank? && @product.save()
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
      original_val = product[params[:property]]
      product[params[:property]] =  params[:value]
      product.save!
      render json: { status: true, value: product[params[:property]] }
    rescue
      render json: { status: false, message: 'operation failure!', value: original_val }
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

  # for locations/:location_id/products
  def relocation
    product = Product.relocation(params[:store_sku], params[:location_id])
    if product
      render json: product.as_json
    else
      render json: { status: 'nok', message: "Not Found."}, status: :not_found
    end
  end

  def create_at_location
    product = Product.new(params[:product].permit!)
    if product.save()
      render json: product.as_json
    else
      render json: { status: 'nok', messages: product.errors.full_messages.as_json}, status: :not_found
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :store_sku, :reg_price, :price, :stock_status, :on_sale, :location_id, :location_info) 
  end
end
