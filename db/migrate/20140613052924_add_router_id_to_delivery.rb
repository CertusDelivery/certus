class AddRouterIdToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :router_id, :integer
  end
end
