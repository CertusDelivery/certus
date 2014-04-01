require 'spec_helper'

describe DeliveryItem do
  before do
    @delivery_item = create(:delivery_item)
  end

  describe "#order_to_delivery_convert" do

    #it "should client_sku match store_sku" do
    #  @delivery_item.client_sku = '2848393'
    #  @delivery_item.store_sku = '1234578997'
    #  @delivery_item.save
    #  @delivery_item.should have(1).error_on(:client_sku)
    #  @delivery_item.errors.messages[:client_sku].first.should == "client_sku doesn't match store_sku"
    #end

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

  describe '#location_rebuild' do
    it 'should return correct field value for location' do
      @delivery_item = create(:delivery_item, :location => '01W--1')
      item = DeliveryItem.find_by_location('01W--1')
      item.location_aisle_num.should == 1
      item.location_direction.should == 'W'
      item.location_front.should == 0
      item.location_shelf.should == 1

      @delivery_item = create(:delivery_item, :location => '2--13')
      item = DeliveryItem.find_by_location('2--13')
      item.location_aisle_num.should == 2
      item.location_direction.should == ''
      item.location_front.should == 0
      item.location_shelf.should == 13

      @delivery_item = create(:delivery_item, :location => '4w-11-')
      item = DeliveryItem.find_by_location('4w-11-')
      item.location_aisle_num.should == 4
      item.location_direction.should == 'W'
      item.location_front.should == 11
      item.location_shelf.should == 0

      @delivery_item = create(:delivery_item, :location => '5e-  23  -09')
      item = DeliveryItem.find_by_location('5e-  23  -09')
      item.location_aisle_num.should == 5
      item.location_direction.should == 'E'
      item.location_front.should == 23
      item.location_shelf.should == 9

    end
  end

  describe '#out_of_stock!' do
    it 'should update out_of_stock_quantity and out_of_stock_quantity should equal to (quantity - picked_quantity)' do
      delivery_item = create(:delivery_item, quantity: 4, picked_quantity: 1, out_of_stock_quantity: 0)
      delivery_item.out_of_stock!
      expect(delivery_item.out_of_stock_quantity).to eq(3)
    end
  end

  describe '#total_price' do
    it 'should get total price' do
      delivery_item = create(:delivery_item, quantity: 3, price: 2.3)
      expect(delivery_item.total_price).to eq(6.9)
    end
  end

  describe '#picked_total_price' do
    it 'should get picked total price' do
      delivery_item = create(:delivery_item, picked_quantity: 2, price: 2.3)
      expect(delivery_item.picked_total_price).to eq(4.6)
    end
  end

end
