class AddFieldsToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :picker_id, :integer
    add_column :deliveries, :picked_status, :string
    add_column :deliveries, :picked_sku_count, :integer
    add_column :deliveries, :picked_piece_count, :integer
    add_column :deliveries, :total_shipping_weight, :decimal
    add_column :deliveries, :total_payment_adjustment, :decimal
    add_column :deliveries, :bin_geocode, :string
    add_column :deliveries, :picked_at, :datetime
    add_column :deliveries, :left_store_at, :datetime
    add_column :deliveries, :hub_driver_id, :integer
    add_column :deliveries, :route_driver_id, :integer
    add_column :deliveries, :route_driver_received_at, :datetime
    add_column :deliveries, :delivered_status, :string
    add_column :deliveries, :message_status, :string
    add_column :deliveries, :gratuity_status, :string
    add_column :deliveries, :delivered_at, :datetime

    #Order relate attributes
    add_column :deliveries, :client_id, :integer
    add_column :deliveries, :store_id, :integer
    add_column :deliveries, :order_id, :integer
    add_column :deliveries, :order_sku_count, :integer
    add_column :deliveries, :order_piece_count, :integer
    add_column :deliveries, :order_total_price, :decimal
    add_column :deliveries, :order_total_tax, :decimal
    add_column :deliveries, :order_total_adjustments, :decimal
    add_column :deliveries, :order_non_apportionable_adjustments, :decimal
    add_column :deliveries, :order_grand_total, :integer
    add_column :deliveries, :order_flag, :string
    add_column :deliveries, :order_status, :string
    add_column :deliveries, :payment_id, :integer
    add_column :deliveries, :payment_card_token, :string
    add_column :deliveries, :payment_amount, :decimal
    add_column :deliveries, :placed_at, :datetime
    add_column :deliveries, :desired_delivery_window, :datetime

    #Customer information
    add_column :deliveries, :customer_name, :string
    add_column :deliveries, :shipping_address, :string
    add_column :deliveries, :customer_email, :string
  end
end