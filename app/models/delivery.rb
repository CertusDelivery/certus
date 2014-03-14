class Delivery < ActiveRecord::Base
  has_many :delivery_items
end
