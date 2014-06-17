require 'eventmachine'
class DeliveryPickerShip < ActiveRecord::Base
  belongs_to :delivery
  belongs_to :picker, class_name: 'User'

  attr_accessor :shared
  
  after_commit :publish_items_for_faye, :on => :create


  private
  def publish_items_for_faye
    if self.shared
      AsyncFayeWorker.perform_async(:delivery_shared, self.id)
    end
  end
end
