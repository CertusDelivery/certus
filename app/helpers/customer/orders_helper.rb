require 'digest/md5'
module Customer::OrdersHelper
  # order == deivery
  def order_secure_url(order)
    secure_order_key = Digest::SHA2.hexdigest("#{order.order_id}#{order.secure_salt}")
    #url.gsub("/#{order.id.to_s}", "/#{secure_order_key}")
    secure_order_key
  end
end
