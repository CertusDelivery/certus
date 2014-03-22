require 'spec_helper'

describe DeliveryItemsController do

  describe '#pick' do
    before do
      @delivery = create_delivery(:picking)
      @delivery_item = @delivery.delivery_items.first
      @delivery_item.picked_status = DeliveryItem::PICKED_STATUS[:unpicked]
      @delivery_item.save
    end

    it "should pick the right item with valid barcode" do
      post :pick, { barcode: @delivery_item.store_sku}
      response.status.should eq 200
    end

    it "should return error for invalid barcode" do
      post :pick, { barcode: '0000'}
      response.status.should eq 422
      response.body.should eq({ status: 'nok', message: 'You scanned the wrong item.'}.to_json)
    end

    it "should retuen error when a delivery item is fully picked" do
      @delivery_item.update_attributes({picked_quantity: @delivery_item.quantity})

      post :pick, { barcode: @delivery_item.store_sku }
      response.status.should eq 422
      response.body.should eq({ status: 'nok', message: 'You scanned the wrong item.'}.to_json)
    end
  end

end
