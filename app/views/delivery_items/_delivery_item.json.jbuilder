json.(item,
  :id,
  :picked_status,
  :product_name,
  :shipping_weight,
  :delivery_id,
  :picker_bin_number,
  :store_sku,
  :quantity,
  :picked_quantity,
  :out_of_stock_quantity,
  :scanned_quantity,
  :picking_progress,
  :is_replaced,
  :product_image,
  :price
)
json.location item.location.info if item.location
