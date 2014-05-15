require 'spec_helper'

describe Customer::OrdersHelper do
  before do
    @order = create_delivery
    Delivery.any_instance.stubs(:publish_items_for_faye)
  end

  describe "order_secure_url" do
    it "should get a secure url for order" do
      expect(helper.order_secure_url(@order)).to eq("http://test.host/customer/orders/#{@order.secure_order_id}")
    end
  end

  describe "order_secure_tag" do
    it "should get a secure tag for order" do
      expect(helper.order_secure_tag(@order)).to eq("<a href=\"http://test.host/customer/orders/#{@order.secure_order_id}\">http://test.host/customer/orders/#{@order.secure_order_id}</a>")
    end
  end

  describe "expected_delivery_window" do
    it "should get correct window" do
      placed_at = Time.utc(2014, 5, 5, 14, 10)
      expect(helper.expected_delivery_window(placed_at)).to eq("2014-05-05 17:00 PM - 18:00 PM")
      placed_at = Time.utc(2014, 5, 5, 14, 16)
      expect(helper.expected_delivery_window(placed_at)).to eq("2014-05-05 17:30 PM - 18:30 PM")
      placed_at = Time.utc(2014, 5, 5, 14, 46)
      expect(helper.expected_delivery_window(placed_at)).to eq("2014-05-05 18:00 PM - 19:00 PM")
    end
  end
end
