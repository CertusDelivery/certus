require 'spec_helper'

describe Customer::OrdersController do
  before do
    @order = create_delivery
    Delivery.any_instance.stubs(:publish_items_for_faye).returns(nil)
  end

  describe "GET show" do
    it "should be visited and render order template" do
      get :show, id: @order.secure_order_id   
      response.status.should == 200
      response.should render_template(:show)
    end
  end

  describe "PUT update" do
    it "should be update order fields" do
      param_delivery = { delivery_option: Delivery::DELIVERY_OPTIONS.values.sample, order_flag: Delivery::ORDER_FLAGS.values.sample }
      put :update, id: @order.secure_order_id, delivery: param_delivery
      @order.reload
      expect(@order.delivery_option).to eq(param_delivery[:delivery_option])
      expect(@order.order_flag).to eq(param_delivery[:order_flag])
    end
  end
end
