require 'spec_helper'

describe DeliveryItem do
  before do
    @delivery_item = FactoryGirl.build(:delivery_item)
  end

  describe "#order_to_delivery_convert" do

    it "should order_grand_total doesn't match payment_amount" do
      @delivery_item.client_sku = '2848393'
      @delivery_item.store_sku = '1234578997'
      @delivery_item.save
      @delivery_item.should have(1).error_on(:client_sku)
      @delivery_item.errors.messages[:client_sku].first.should == "order_grand_total doesn't match payment_amount"
    end

  end
end
