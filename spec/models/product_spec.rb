require 'spec_helper'

describe Product do
  describe "#relocation" do
    before do
      @location = Location.create_by_info("A10E-32-12")
      @product = Product.create(name: "product name", store_sku: "534550181")
    end

    it "should return nil when use invalid param" do
      Product.relocation('1', '').should be_nil
      Product.relocation('', '1').should be_nil
    end

    it "should change product location" do
      expect { Product.relocation(@product.store_sku, @location.id) }.to change { Product.find(@product.id).location}.from(nil).to(@location) 
    end
  end

  describe "#out_of_stock!" do
    before do
      @product = Product.create(name: "product name", store_sku: "534550181")
    end

    it "should set product's stock status to be OUT_OF_STOCK" do
      @product.out_of_stock!
      expect(@product.stock_status).to eq('OUT_OF_STOCK')
    end
  end
end
