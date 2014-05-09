class DeliveryPickerShip < ActiveRecord::Base
  belongs_to :delivery
  belongs_to :picker, class_name: 'User'
end
