class ModifyDeliveryItems < ActiveRecord::Migration
  def change
    rename_column :delivery_items, :client_slu, :client_sku

  end
end
