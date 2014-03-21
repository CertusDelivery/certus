require 'spec_helper'

describe Delivery do
  before do
    @delivery = create_delivery
  end

  describe "#validate customer_name,shipping_address,customer_email" do

    it "should be invalid when customer_name is blank" do
      @delivery.customer_name = ''
      @delivery.save
      @delivery.valid?.should be_false
      @delivery.should have(1).error_on(:customer_name)
      @delivery.errors.messages[:customer_name].first.should == "can't be blank"
    end

    it "should be invalid when shipping_address is blank" do
      @delivery.shipping_address = ''
      @delivery.save
      @delivery.valid?.should be_false
      @delivery.should have(1).error_on(:shipping_address)
      @delivery.errors.messages[:shipping_address].first.should == "can't be blank"
    end

    it "should be invalid when customer_email is blank" do
      @delivery.customer_email = ''
      @delivery.save
      @delivery.valid?.should be_false
      @delivery.should have(2).error_on(:customer_email)
      @delivery.errors.messages[:customer_email].first.should == "can't be blank"
      @delivery.errors.messages[:customer_email].second.should == "customer email must be valid"
    end

  end

  describe "#order_to_delivery_convert" do

    it "should order_grand_total doesn't match payment_amount" do
      @delivery.order_grand_total = 100
      @delivery.payment_amount = 200
      @delivery.save
      @delivery.should have(1).error_on(:order_grand_total)
      @delivery.errors.messages[:order_grand_total].first.should == "order_grand_total doesn't match payment_amount"
    end

    it "should sku_count doesn't match number of order_items" do
      @delivery.order_sku_count = 999
      @delivery.save
      @delivery.should have(1).error_on(:order_sku_count)
      @delivery.errors.messages[:order_sku_count].first.should == "sku_count doesn't match number of order_items"
    end

    it "should total price doesn't match the sum of all order_items price" do
      @delivery.order_total_price = 9999
      @delivery.save
      @delivery.should have(1).error_on(:order_total_price)
      @delivery.errors.messages[:order_total_price].first.should == "total price doesn't match the sum of all order_items price"
    end


  end

end
