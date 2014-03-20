json.array!(@deliveries.map(&:delivery_items).flatten) do |item|
  json.(item,
    :id,
    :picked_status,
    :product_name,
    :shipping_weight,
    :location,
    :delivery_id,
    :picker_bin_number,
    :store_sku,
    :quantity,
    :picked_quantity,
    :out_of_stock_quantity,
    :scanned_quantity
  )
  json.picking_progress  "#{item.quantity}/#{item.picked_quantity}/#{item.out_of_stock_quantity}/#{item.scanned_quantity}"

end