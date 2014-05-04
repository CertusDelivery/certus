class SetSecureUrlForOriginalProduct < ActiveRecord::Migration
  def change
    Delivery.all.each do |delivery|
      if delivery.secure_order_id.blank?
        delivery.secure_salt = SecureRandom.hex(10)
        delivery.secure_order_id  = Digest::SHA2.hexdigest("#{delivery.order_id}#{delivery.secure_salt}")
        delivery.save
      end
    end
  end
end
