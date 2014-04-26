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

  describe '#out_of_stock!' do
    it 'should update out_of_stock_quantity and out_of_stock_quantity should equal to (quantity - picked_quantity)' do
      delivery_item = create(:delivery_item, quantity: 4, picked_quantity: 1, out_of_stock_quantity: 0)
      product = create(:product, store_sku: delivery_item.store_sku)
      product.stubs(:propagate_to_client)
      delivery_item.out_of_stock!
      expect(delivery_item.out_of_stock_quantity).to eq(3)
      expect(delivery_item.product.stock_status).to eq('OUT_OF_STOCK')
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

  describe '.substitute' do
    before do
      @original_item = create(:delivery_item, quantity: 5, picked_quantity: 2, picked_status: DeliveryItem::PICKED_STATUS[:picked], out_of_stock_quantity: 3)
      @product_params = ActionController::Parameters.new(product_name: "Alternative Product", client_sku: '1010101010101010', store_sku: '1010101010101010', price: 50.0, tax: 4.0, other_adjustments: 0) 
    end

    it 'should create a new delivery item' do
      expect{ DeliveryItem.substitute(@original_item, @product_params) }.to change(DeliveryItem, :count).by(1)
    end

    it 'should create substitute item with right quantities' do
      substitute_item = DeliveryItem.substitute(@original_item, @product_params)
      
      expect(substitute_item.quantity).to eq(@original_item.out_of_stock_quantity)
      expect(substitute_item.picked_quantity).to eq(1)
    end
  end

  describe '#substitute_for' do
    before do
      @original_item =  create(:delivery_item, quantity: 5, picked_quantity: 2, picked_status: DeliveryItem::PICKED_STATUS[:picked], out_of_stock_quantity: 3)
      @substitue_item = create(:delivery_item)
    end

    it 'should add out-of-stock quantity to substitute' do
      expect{ @substitue_item.substitute_for(@original_item)}.to change(@substitue_item, :quantity).by(@original_item.out_of_stock_quantity)
    end

    it 'should automatically add one to the picked quantity of substitute' do
      expect{ @substitue_item.substitute_for(@original_item)}.to change(@substitue_item, :picked_quantity).by(1)
    end
  end

  describe '#replace!' do
    it 'should mark one item as replaced' do
      delivery_item = create(:delivery_item)
      expect{ delivery_item.replace! }.to change(delivery_item, :is_replaced).from(false).to(true)
    end
  end

end
