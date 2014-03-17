json.array!(@deliveries.map(&:delivery_items).flatten) do |item|
  json.(item, :id, :picked_status, :product_name, :shipping_weight, :location, :delivery_id, :picker_bin_number, :store_sku)
end