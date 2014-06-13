module Router
  class DeliveriesController < RouterController
    def index
      @deliveries = current_user.route_list.page(params[:page])
    end

    def unroute
      @deliveries = Delivery.unroute.page(params[:page])
    end

    def add
      Delivery.where(id: params[:deliveries]).each do |delivery|
        delivery.out_for_delivery current_user 
      end
      redirect_to router_url
    end
  end
end
