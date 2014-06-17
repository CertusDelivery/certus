require 'spec_helper'
require 'authlogic/test_case'

describe DeliveriesController do
  include Authlogic::TestCase
  before do
    Delivery.any_instance.stubs(:publish_items_for_faye)
    DeliveryItem.any_instance.stubs(:publish_item_for_faye)
    activate_authlogic
    @user = create(:user)
    UserSession.create(@user)
    controller.stubs(:current_user).returns(@user)
  end

  describe "#create" do
    it 'should filt error params when post error params' do
      param = create_delivery_params
      param[:delivery][:no_filed] = 'no filed in db'
      post :create, param
      response.body.should =={:status => :ok, order: {order_status: 'IN_FULFILLMENT',estimated_delivery_window:controller.instance_variable_get(:@delivery).desired_delivery_window }}.to_json
      response.status.should == 200
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
      3.times { create_delivery }
      2.times do
        @user.deliveries << create_delivery(:picking)
      end
      @user.save
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
      3.times { create_delivery }
      2.times { create_delivery(:picking) }
    end

    it 'should return unpicked_orders count' do
      get :unpicked_orders
      response.success?.should be_true
      response.body.to_i.should == 3
    end
  end

  describe '#load_unpicked_order' do
    before do
      3.times { create_delivery }
      1.times do
        picking_delivery = create_delivery(:picking)
        @user.deliveries << picking_delivery
        @user.save
      end
    end

    it 'should load one order into picklist' do
      Delivery.picking.count.should == 1
      Delivery.unpicked.count.should == 3
      get :load_unpicked_order
      response.should render_template('deliveries/picklist.json')
      assigns[:deliveries].size.should == 2
      @user.deliveries.picking.count.should == 2
      Delivery.unpicked.count.should == 2
    end

    it 'should not load new order into picklist when current picking orders count equal to MAX_PICKING_COUNT' do
      2.times do
        @user.deliveries << create_delivery(:picking)
      end
      @user.save
      @user.deliveries.picking.count.should == 3
      Delivery.unpicked.count.should == 3
      get :load_unpicked_order
      response.should render_template('deliveries/picklist.json')
      assigns[:deliveries].size.should == 3
      @user.deliveries.picking.count.should == 3
      Delivery.unpicked.count.should == 3
    end
  end

  describe '#remove_picked_orders' do
    before do
      2.times do 
        @user.deliveries << create_delivery(:picking)
      end
      @user.save
      3.times { create_delivery }
      @user.deliveries.picking.each do |d|
        d.delivery_items.each{|item| item.pick!(item.quantity)}
      end
    end

    it 'should return json with message "2 orders have been removed from the list."' do
      delete :remove_picked_orders
      expect(response.success?).to be_true
      data = JSON.parse(response.body)
      expect(data["message"]).to eq("2 orders have been removed from the list.")
    end
  end

  describe '#sort_picking_orders' do
    before do
      #delivery 1
      delivery = FactoryGirl.build :delivery, :picking, order_sku_count: 3
      @user.deliveries << delivery
      total_price = 0

      @delivery_item_1 = FactoryGirl.build(:delivery_item)
      location1 = Location.new(aisle: '02', direction: 'W', distance: 1, shelf: 9)
      product1 = FactoryGirl.create(:product, store_sku: @delivery_item_1.store_sku, location: location1)
      delivery.delivery_items << @delivery_item_1
      total_price += @delivery_item_1.price

      @delivery_item_2 = FactoryGirl.build(:delivery_item)
      location2 = Location.new(aisle: '02', direction: 'W', distance: 2, shelf: 9)
      product2 = FactoryGirl.create(:product, store_sku: @delivery_item_2.store_sku, location: location2)
      delivery.delivery_items << @delivery_item_2
      total_price += @delivery_item_2.price

      @delivery_item_3 = FactoryGirl.build(:delivery_item)
      location3 = Location.new(aisle: '02', direction: '', distance: 1, shelf: 19)
      product3 = FactoryGirl.create(:product, store_sku: @delivery_item_3.store_sku, location: location3)
      delivery.delivery_items << @delivery_item_3
      total_price += @delivery_item_3.price

      delivery.payment_amount = delivery.order_grand_total = delivery.order_total_price = total_price
      delivery.save!
      #delivery 2
      delivery2 = FactoryGirl.build :delivery, :picking, order_sku_count: 2
      @user.deliveries << delivery2
      total_price = 0

      @delivery2_delivery_item_4 = FactoryGirl.build(:delivery_item)
      location4 = Location.new(aisle: '01', direction: 'E', distance: 1, shelf: 9)
      product4 = FactoryGirl.create(:product, store_sku: @delivery2_delivery_item_4.store_sku, location: location4)
      delivery2.delivery_items << @delivery2_delivery_item_4
      total_price += @delivery2_delivery_item_4.price

      @delivery2_delivery_item_5 = FactoryGirl.build(:delivery_item)
      location5 = Location.new(aisle: '02', direction: 'E', distance: 2, shelf: 29)
      product5 = FactoryGirl.create(:product, store_sku: @delivery2_delivery_item_5.store_sku, location: location5)
      delivery2.delivery_items << @delivery2_delivery_item_5
      total_price += @delivery2_delivery_item_5.price
      delivery2.payment_amount = delivery2.order_grand_total = delivery2.order_total_price = total_price
      delivery2.save!
    end

    it 'should return correct sort delivery_items by location asc' do
      #sort asc ['01E-1-9', '02-01-19', '02E-02-29', '02W-01-9', '2W-2-9']
      get :sort_picking_orders, {direction: 'asc'}, format: :json
      controller.instance_variable_get(:@delivery_items).should == [@delivery2_delivery_item_4, @delivery_item_3, @delivery2_delivery_item_5, @delivery_item_1, @delivery_item_2]
    end

    it 'should return correct sort delivery_items by location desc' do
      #sort desc ['02W-2-9', '02W-01-9','2E-02-29','02-01-19','01E-1-9']
      get :sort_picking_orders, {direction: 'desc'}, format: :json
      controller.instance_variable_get(:@delivery_items).should == [@delivery_item_2,@delivery_item_1, @delivery2_delivery_item_5, @delivery_item_3,@delivery2_delivery_item_4]
    end

  end

end
