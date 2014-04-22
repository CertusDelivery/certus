class LocationsController < ApplicationController
  protect_from_forgery except: [:create_by_info]
  def index
    if params[:search].blank?
      @locations = Location.includes(:products).paginate(per_page: 15, page: params[:page])
    else
      @locations = Location.where("info=?", params[:search])
      if @locations.size != 0
        redirect_to location_path(@locations.first)
      end
    end
  end
  
  def show
    @location = Location.find(params[:id])
  end

  def create_by_info
    location = Location.create_by_info(params[:info])
    if location
        render json: {status: true, url: location_url(location)}
    else
        render json: {status: false, mess: 'invalid location!'}
    end
  end
end
