module Admin
  class DeliveriesController < AdminController

    def history
      @deliveries = Delivery.includes(:delivery_items).where('id in (select delivery_id from delivery_items where picked_quantity != 0)').page(params[:page]).order('placed_at desc')
    end
  end
end
