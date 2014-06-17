json.array!(@deliveries) do |d|
  json.(d,
    :id,
    :shipping_address,
    :latitude,
    :longitude,
    :quantity,
    :placed_at,
    :expected_delivery_window
  )
end
