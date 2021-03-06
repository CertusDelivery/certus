require 'spec_helper'
require 'authlogic/test_case'

describe DeliveryItemsController do
  include Authlogic::TestCase
  before do
    Product.any_instance.stubs(:propagate_to_client)
    Delivery.any_instance.stubs(:publish_items_for_faye)
    DeliveryItem.any_instance.stubs(:publish_item_for_faye)
    activate_authlogic
    @user = create(:user)
    UserSession.create(@user)
    controller.stubs(:current_user).returns(@user)
  end

  describe '#pick' do
    before do
      @delivery = create_delivery(:picking)
      @delivery_item = @delivery.delivery_items.first
      @delivery_item.picked_status = DeliveryItem::PICKED_STATUS[:unpicked]
      @delivery_item.save
    end

    it "should pick the right item with valid barcode" do
      post :pick, { barcode: @delivery_item.store_sku, format: :json }
      response.status.should eq 200
    end

    it "should return error for invalid barcode" do
      post :pick, { barcode: '0000'}
      response.status.should eq 422
      response.body.should eq({ status: 'nok', message: 'You scanned the wrong item.'}.to_json)
    end

    it "should return error when a delivery item is fully picked" do
      @delivery_item.update_attributes({picked_quantity: @delivery_item.quantity})

      post :pick, { barcode: @delivery_item.store_sku }
      response.status.should eq 422
      response.body.should eq({ status: 'nok', message: 'You scanned the wrong item.'}.to_json)
    end

    context 'when the barcode is a specific barcode' do
      it 'should update out_of_stock_quantity when barcode is "OUT_OF_STOCK"' do 
        post :pick, { barcode: "OUT_OF_STOCK", id: @delivery_item.id, delivery_id: @delivery.id, format: :json }
        response.status.should eq 200
        expect(assigns[:delivery_item].out_of_stock_quantity).to eq(@delivery_item.quantity)
        expect(assigns[:delivery_item].picked_status).to eq(DeliveryItem::PICKED_STATUS[:picked])
      end

      it 'should update delivery status to STORE_STAGING when barcode is "REMOVE_COMPLETED_DELIVERY"' do 
        @delivery.delivery_items.each{|item| item.pick!(item.quantity)}
        post :pick, { barcode: "REMOVE_COMPLETED_DELIVERY", id: @delivery_item.id, delivery_id: @delivery.id, format: :json }
        data = JSON.parse(response.body)
        expect(data["remove_completed_delivery"]).to be_true
        expect(data["status"]).to eq('ok')
      end
    end
  end


  describe '#check_barcode' do
    before do
      @delivery = create_delivery(:picking)
      @delivery_item = @delivery.delivery_items.first
      @delivery_item.picked_status = DeliveryItem::PICKED_STATUS[:unpicked]
      @delivery_item.save
      @other_delivery = create_delivery(:picking)
      @other_delivery_item = @other_delivery.delivery_items.first
      @other_delivery_item.picked_status = DeliveryItem::PICKED_STATUS[:unpicked]
      @other_delivery_item.save
    end

    it "should find delivery item by id when user scaned active product" do
      DeliveryItem.expects(:find_by_store_sku).never
      post :pick, { barcode: @delivery_item.store_sku, id: @delivery_item.id, delivery_id: @delivery.id, format: :json }
      expect(assigns[:delivery_item].id).to eq(@delivery_item.id)
    end

    it "should find delivery item by id when user scaned not active product" do
      post :pick, { barcode: @delivery_item.store_sku, id: @other_delivery_item.id, delivery_id: @other_delivery.id, format: :json }
      expect(assigns[:delivery_item].id).to eq(@delivery_item.id)
    end
  end

end
