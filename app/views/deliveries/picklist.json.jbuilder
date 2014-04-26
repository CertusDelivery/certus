json.array!(@delivery_items) do |item|
  json.partial! 'delivery_items/delivery_item', item: item
end
