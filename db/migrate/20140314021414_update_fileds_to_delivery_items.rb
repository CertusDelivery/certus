class UpdateFiledsToDeliveryItems < ActiveRecord::Migration
  def change
    add_column :delivery_items, :additional, :text
    change_column :delivery_items, :store_sku, :string
    change_column :delivery_items, :substitute_sku, :string
  end
end
