class DeliveryPickerShip < ActiveRecord::Base
  belongs_to :delivery
  belongs_to :picker, class_name: 'User'

  attr_accessor :shared

  after_create :publish_items_for_faye


  private
  def publish_items_for_faye
    if self.shared
      client = Faye::Client.new(Setting.faye_server)
      client.publish('/delivery/shared', {picker_id: self.picker_id, items: self.delivery.delivery_items.map(&:as_hash)})
    end
  end
end
