require 'spec_helper'

describe DeliveryItem do
  before do
    @delivery_item = create(:delivery_item)
  end

  describe "#order_to_delivery_convert" do

    it "should client_sku match store_sku" do
      @delivery_item.client_sku = '2848393'
      @delivery_item.store_sku = '1234578997'
      @delivery_item.save
      @delivery_item.should have(1).error_on(:client_sku)
      @delivery_item.errors.messages[:client_sku].first.should == "client_sku doesn't match store_sku"
    end

  end

  describe "#pick!" do
    it "should add 1 to picked quantity" do
      expect{@delivery_item.pick!}.to change(@delivery_item, :picked_quantity).by(1)
    end

    it "should set picked status to PICKED if fully picked" do
      expect{@delivery_item.pick!(@delivery_item.quantity)}.to change(@delivery_item, :picked_status).to(DeliveryItem::PICKED_STATUS[:picked])
    end
  end

  describe "specific_barcode?" do
    it 'should return true when pass a specific barcode' do
      DeliveryItem::SPECIFIC_BARCODES.each_value do |v|
        expect(DeliveryItem.specific_barcode?(v)).to be_true
      end
    end

    it 'should respond to ? methods' do
      DeliveryItem::SPECIFIC_BARCODES.each_key do |k|
        expect(DeliveryItem.respond_to?("#{k}?".to_sym)).to be_true
      end
    end
  end

  describe 'picked?' do
    it 'should return true when the product has been picked' do
      @delivery_item.pick!(@delivery_item.quantity)
      expect(@delivery_item.picked?).to be_true
    end
  end

end
