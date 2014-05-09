require 'time_ext'
module Customer::OrdersHelper
  # order == deivery
  def order_secure_url(order)
    customer_order_url(order).gsub("/#{order.id.to_s}", "/#{order.secure_order_id}")
  end

  def order_secure_tag(order)
    secure_url = order_secure_url order
    content_tag 'a', href: secure_url do
      secure_url
    end
  end

  def expected_delivery_window(placed_at)
    "#{(placed_at+3.hours).round_off(30.minutes).strftime("%Y-%m-%d %H:%M %p")} - #{(placed_at+4.hours).round_off(30.minutes).strftime("%H:%M %p")}"
  end
end
