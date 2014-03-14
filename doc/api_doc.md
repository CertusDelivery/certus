# Workflow Server API

This is the documentation for the APIs exposed through the Certus Workflow Server to the clients.

## URL

http://domain/deliveries

## Data Format

JSON

## HTTP Request Method

POST

## Authentication

todo

## Request Parameters

<table>
  <thead>
    <tr>
      <td>Key</td>
      <td>Required</td>
      <td>Type</td>
      <td>Comments</td>
    </tr>
  </thead>
  
  <tbody>
    <tr>
      <td>customer</td>
      <td>true</td>
      <td>Object</td>
      <td>Customer Information</td>
    </tr>
    
    <tr>
      <td>order</td>
      <td>true</td>
      <td>Object</td>
      <td>Order attributes</td>
    </tr>
    
    <tr>
      <td>order_items</td>
      <td>true</td>
      <td>Array</td>
      <td>An array contains order items object</td>
    </tr>    
  </tbody>
</table>

### Details

todo

### Request Sample

```json
{
  customer:
    {
      "name": "Jane Doe",
      "shipping_address": "979 Gerlach Villages Apt. 126 Port Annettastad",
      "email": "jave1670@example.com"
    },
  order:
    {
      "order_placed_timestamp": "2007-11-09 11:20:25 UTC",
      "desired_deliverywindow": "",
      "client_id": "",
      "store_id": "",
      "client_internal_order_id": "",
      "sku_count": "",
      "piece_count": 3,
      "total_price": 106.0,
      "total_tax": 8.2,
      "total_item_adjustments": "adjustments",
      "non_apportionable_adjustments": "",
      "grand_total": "",
      "client_payment_id": "",
      "payment_card_token": "",
      "payment_amount": "",
      "order_options_flags": "",
      "order_status": ""
    },
  order_items: [
    {
      "client_sku": "NHK1480",
      "quantity": 2,
      "price": 23.0,
      "tax": 1.8,
      "other_adjustments": "adjustments",
      "order_item_amount": "",
      "order_item_options_flags": "backorder"
    },
    {
      "client_sku": "AKT5687",
      "quantity": 1,
      "price": 62.0,
      "tax": 4.6,
      "other_adjustments": "adjustments",
      "order_item_amount": "",
      "order_item_options_flags": "backorder"
    }
  ]
}

```


## Returns

todo

## Other Comments