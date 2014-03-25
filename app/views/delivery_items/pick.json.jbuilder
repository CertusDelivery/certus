json.id @delivery_item.id
json.delivery_item { json.partial! 'delivery_item', item: @delivery_item }
