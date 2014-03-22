require 'spec_helper'

describe DeliveriesController do

  describe "#create" do
    it 'should response 400 when post error params' do
      param = create_delivery_params
      param[:delivery][:no_filed] = 'no filed in db'
      post :create, param
      response.body.should == {:status => :nok, reason: 'Invalid Order'}.to_json
      response.status.should == 400
    end

    it 'should response validate errors when post wrong params' do
      post_params = create_delivery_params
      post_params[:delivery][:customer_name] = nil
      post :create, post_params
      response.body.should == {:status => :nok, reason: controller.instance_variable_get(:@delivery).errors.full_messages}.to_json
      response.status.should == 422
    end

    it 'should response when post correct params' do
      post_params = create_delivery_params
      post :create, post_params
      response.body.should =={:status => :ok, order: {order_status: 'IN_FULFILLMENT',estimated_delivery_window:controller.instance_variable_get(:@delivery).desired_delivery_window }}.to_json
      response.status.should == 200
    end

  end

  describe '#picklist' do
    before do
      3.times { |i| create_delivery }
      2.times { |i| create_delivery(:picking) }
    end

    it 'should render picklist template when format is html' do
      get :picklist
      response.status.should == 200
      response.should render_template(:picklist)
    end

    it 'should render picklist when format is json' do
      get :picklist, format: :json
      response.success?.should be_true
      response.should render_template(:picklist)
      assigns[:deliveries].size.should == 2
    end
  end

  describe '#unpicked_orders' do
    before do
      3.times { |i| create_delivery }
      2.times { |i| create_delivery(:picking) }
    end

    it 'should return unpicked_orders count' do
      get :unpicked_orders
      response.success?.should be_true
      response.body.to_i.should == 3
    end
  end

  describe '#load_unpicked_order' do
    before do
      3.times { |i| create_delivery }
      1.times { |i| create_delivery(:picking) }
    end

    it 'should load one order into picklist' do
      Delivery.picking.count.should == 1
      Delivery.unpicked.count.should == 3
      get :load_unpicked_order
      response.should render_template('deliveries/picklist.json')
      assigns[:deliveries].size.should == 2
      Delivery.picking.count.should == 2
      Delivery.unpicked.count.should == 2
    end

    it 'should not load new order into picklist when current picking orders count equal to MAX_PICKING_COUNT' do
      2.times { |i| create_delivery(:picking) }
      Delivery.picking.count.should == 3
      Delivery.unpicked.count.should == 3
      get :load_unpicked_order
      response.should render_template('deliveries/picklist.json')
      assigns[:deliveries].size.should == 3
      Delivery.picking.count.should == 3
      Delivery.unpicked.count.should == 3
    end
  end
end
