json.array!(@deliveries.map(&:delivery_items).flatten) do |json, item|
  json.partial! 'delivery_items/delivery_item', item: item
end
