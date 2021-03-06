require 'spec_helper'

describe Delivery do
  before do
    @delivery = create_delivery
    Delivery.any_instance.stubs(:publish_items_for_faye)
    DeliveryItem.any_instance.stubs(:publish_item_for_faye)
    AsyncMailWorker.stubs(:perform_async)
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

    # it "should sku_count doesn't match number of order_items" do
    #   @delivery.order_sku_count = 999
    #   @delivery.save
    #   @delivery.should have(1).error_on(:order_sku_count)
    #   @delivery.errors.messages[:order_sku_count].first.should == "sku_count doesn't match number of order_items"
    # end

    # it "should total price doesn't match the sum of all order_items price" do
    #   @delivery.order_total_price = 9999
    #   @delivery.save
    #   @delivery.should have(1).error_on(:order_total_price)
    #   @delivery.errors.messages[:order_total_price].first.should == "total price doesn't match the sum of all order_items price"
    # end


  end

  describe "all_picked?" do
    it "should return false when the delivery has not been complete picked" do
      expect(@delivery.delivery_items.all_picked?).to be_false
    end

    it "should return true when the delivery has been complete picked" do
      @delivery.delivery_items.each {|item| item.pick!(item.quantity)}
      expect(@delivery.delivery_items.all_picked?).to be_true
    end
  end

  describe "? methods" do
    it "should respond to ? methods" do
      Delivery::PICKED_STATUS.each_key do |k|
        expect(@delivery.respond_to?("#{k}?")).to be_true
      end
    end
  end

  describe "#can_be_complete?" do
    it "should return false when the delivery has not been complete picked" do
      expect(@delivery.can_be_complete?).to be_false
    end

    it "should return true when the delivery has been complete picked" do
      @delivery.delivery_items.each {|item| item.pick!(item.quantity)}
      expect(@delivery.can_be_complete?).to be_true
    end
  end

  describe "#complete!" do
    it "should complete the delivery when the delivery can be complete" do
      @delivery.delivery_items.each {|item| item.pick!(item.quantity)}
      expect(@delivery.can_be_complete?).to be_true
      @delivery.complete!
      expect(@delivery.store_staging?).to be_true
      expect(@delivery.message_status).to eq(Delivery::MESSAGE_STATUS[:picked])
    end
  end

  describe ".complete_all_for_user" do
    before do
      @user     = create(:user)
    end
    context 'when no order has been completed picked' do
      it 'should return message "No order have been completed picked."' do
        expect(Delivery.complete_all_for_user(@user)).to eq("No order have been completed picked.")
      end
    end

    context 'when one order has been completed picked' do
      before do
        @delivery = create_delivery(:picking)
        @delivery.delivery_items.each {|item| item.pick!(item.quantity)}
        @user.deliveries << @delivery
        @user.save
      end

      it 'should return message "1 order have been removed from the list."' do
        expect(Delivery.complete_all_for_user(@user)).to eq("1 order have been removed from the list.")
      end
    end



    context 'when two order has been completed picked' do
      before do
        deliverie1 = create_delivery(:picking)
        deliverie2 = create_delivery(:picking)
        deliverie3 = create_delivery(:picking)
        [deliverie1, deliverie2].each do |d|
          d.delivery_items.each {|item| item.pick!(item.quantity)}
        end
        @user.deliveries << deliverie1
        @user.deliveries << deliverie2
        @user.deliveries << deliverie3
        @user.save
      end

      it 'should return message "2 orders have been removed from the list."' do
        expect(Delivery.complete_all_for_user(@user)).to eq("2 orders have been removed from the list.")
      end
    end
  end

  describe "call(refer delivery items)" do
    before do  
      delivery_item1 = create(:delivery_item, picked_quantity: 3, out_of_stock_quantity: 1, price: 3.2, delivery_id: @delivery.id)
      delivery_item2 = create(:delivery_item, picked_quantity: 2, out_of_stock_quantity: 0, price: 1.1, delivery_id: @delivery.id)
      delivery_item3 = create(:delivery_item, picked_quantity: 0, out_of_stock_quantity: 5, price: 2.7, delivery_id: @delivery.id)
      @delivery.reload
    end

    describe "#picked_total_price" do
      it "should get sum all picked delivery items total price" do
        expect(@delivery.picked_total_price).to eq(11.8)
      end
    end

    describe "#picked_quantity" do
      it "should get sum all picked delivery items total picked_quantity" do
        expect(@delivery.picked_quantity).to eq(5)
      end
    end

    describe "#out_of_stock_quantity" do
      it "should get sum all out of stock delivery items total out_of_stock_quantity" do
        expect(@delivery.out_of_stock_quantity).to eq(6)
      end
    end
    
    describe "#change_order_items_options_flags" do
      it 'should be changed when its order\'s order flag changed' do
        flags = Delivery::ORDER_FLAGS.values
        flags.delete(@delivery.order_flag)
        @delivery.update(order_flag: flags.sample)
        @delivery.reload
        @delivery.delivery_items.each do |item|
          expect(item.order_item_options_flags).to eq(@delivery.order_flag)
        end
      end
    end
  end

  describe "#initial_status" do
    it 'should initial delivery status' do
      expect(@delivery.picked_status).to eq(Delivery::PICKED_STATUS[:unpicked])
      expect(@delivery.message_status).to eq(Delivery::MESSAGE_STATUS[:received])
    end
  end

  describe "#initial_secure_url" do
    it 'should initial secure_order_id' do
      @delivery.secure_order_id.should_not nil
    end
  end

  describe "#add_msg_into_flash" do
    it 'should get flash notic when order delivery_option changed' do
      delivery_options = Delivery::DELIVERY_OPTIONS.values
      delivery_options.delete(@delivery.delivery_option)
      @delivery.update(delivery_option: delivery_options.sample)
      expect(@delivery.flash_notice).to eq("Your driver will be notified of any changes you make to the delivery option for your order.")
    end
  end
end
