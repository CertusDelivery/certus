# Workflow Server API

This is the documentation for the APIs exposed through the Certus Workflow Server to the clients.

## URL

```
http://#{domain}/deliveries
```

## Data Format

```
JSON
```

## HTTP Request Method

```
POST
```

## Authentication

todo

## Request Parameters

<table>
  <thead>
    <tr>
      <td>Parameter</td>
      <td>Required</td>
      <td>Type</td>
      <td>Comments</td>
    </tr>
  </thead>
  
  <tbody>
    <tr>
      <td>delivery</td>
      <td>true</td>
      <td>Object</td>
      <td>Attributes for delivery, including cumstomer and order information</td>
    </tr>
  </tbody>
</table>

### Delivery

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
      <td>customer_name</td>
      <td>true</td>
      <td>String</td>
      <td>No more than 255 chars</td>
    </tr>

    <tr>
      <td>shipping_address</td>
      <td>true</td>
      <td>String</td>
      <td>No more than 255 chars</td>
    </tr>

    <tr>
      <td>customer_email</td>
      <td>true</td>
      <td>String</td>
      <td>No more than 255 chars</td>
    </tr>

    <tr>
      <td>placed_at</td>
      <td>true</td>
      <td>String</td>
      <td>Order placed timestamp</td>
    </tr>

    <tr>
      <td>desired_delivery_window</td>
      <td>true</td>
      <td>String</td>
      <td>Desired delivery time</td>
    </tr>

    <tr>
      <td>client_id</td>
      <td>true</td>
      <td>Integer</td>
      <td></td>
    </tr>

    <tr>
      <td>store_id</td>
      <td>true</td>
      <td>Integer</td>
      <td></td>
    </tr>

    <tr>
      <td>order_id</td>
      <td>true</td>
      <td>Integer</td>
      <td>Client internal order ID</td>
    </tr>

    <tr>
      <td>order_sku_count</td>
      <td>true</td>
      <td>Integer</td>
      <td>Order totals:	SKU count</td>
    </tr>

    <tr>
      <td>order_piece_count</td>
      <td>true</td>
      <td>Integer</td>
      <td>Order totals:	piece count</td>
    </tr>

    <tr>
      <td>order_total_price</td>
      <td>true</td>
      <td>Float</td>
      <td>Order totals:	price</td>
    </tr>

    <tr>
      <td>order_total_tax</td>
      <td>true</td>
      <td>Float</td>
      <td>Order totals:	tax</td>
    </tr>

    <tr>
      <td>order_total_adjustments</td>
      <td>false</td>
      <td>Float</td>
      <td>Order totals:	adjustments, defaults to 0.0</td>
    </tr>

    <tr>
      <td>order_non_apportionable_adjustments</td>
      <td>false</td>
      <td>Float</td>
      <td>Order totals:	Non apportionable adjustments, defaults to 0.0</td>
    </tr>

    <tr>
      <td>order_grand_total</td>
      <td>true</td>
      <td>Float</td>
      <td>Order totals: Grand_total</td>
    </tr>

    <tr>
      <td>payment_id</td>
      <td>true</td>
      <td>Interger</td>
      <td>Client Payment ID</td>
    </tr>

    <tr>
      <td>payment_card_token</td>
      <td>true</td>
      <td>String</td>
      <td>Client payment card token</td>
    </tr>

    <tr>
      <td>payment_amount</td>
      <td>true</td>
      <td>Float</td>
      <td>Client payment amount</td>
    </tr>

    <tr>
      <td>order_flag</td>
      <td>true</td>
      <td>String</td>
      <td></td>
    </tr>

    <tr>
      <td>order_status</td>
      <td>true</td>
      <td>String</td>
      <td></td>
    </tr>

    <tr>
      <td>order_items</td>
      <td>true</td>
      <td>Array</td>
      <td>An array contains order items object</td>
    </tr>
  </tbody>
</table>

### Order Item

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
      <td>client_sku</td>
      <td>true</td>
      <td>String</td>
      <td></td>
    </tr>

    <tr>
      <td>quantity</td>
      <td>true</td>
      <td>Float</td>
      <td></td>
    </tr>

    <tr>
      <td>shipping_weight_unit</td>
      <td>false</td>
      <td>String</td>
      <td></td>
    </tr>

    <tr>
      <td>price</td>
      <td>true</td>
      <td>Float</td>
      <td>price per unit</td>
    </tr>

    <tr>
      <td>tax</td>
      <td>true</td>
      <td>Float</td>
      <td>tax per unit</td>
    </tr>

    <tr>
      <td>other_adjustments</td>
      <td>false</td>
      <td>Float</td>
      <td>Defaults to 0.0</td>
    </tr>

    <tr>
      <td>order_item_amount</td>
      <td>true</td>
      <td>Float</td>
      <td></td>
    </tr>

    <tr>
      <td>order_item_options_flags</td>
      <td>true</td>
      <td>String</td>
      <td>Available options: "substitute", "backorder", "critical", "skip" <br/>
          substitute: Substitute item if out of stock,<br/>
          backorder: Backorder item if out of stock and re-deliver when item is available,<br/>
          critical: Cancel order if item is out of stock,<br/>
          skip: Cancel this item only if out of stock,<br/>
      </td>
    </tr>

  </tbody>
</table>


Request Sample

```json
{
  "delivery":
  {
    "customer_name": "Jane Doe",
    "shipping_address": "979 Gerlach Villages Apt. 126 Port Annettastad",
    "customer_email": "jave1670@example.com"
    "order_placed_timestamp": "2014-04-09 11:20:25 UTC",
    "desired_deliverywindow": "2014-04-12",
    "client_id": 205697,
    "store_id": 9781,
    "client_internal_order_id": 6585395783,
    "sku_count": 3,
    "piece_count": 3,
    "total_price": 106.0,
    "total_tax": 8.2,
    "total_item_adjustments": -12.8,
    "non_apportionable_adjustments": 0.0,
    "grand_total": 93.2,
    "client_payment_id": 7256,
    "payment_card_token": "NSpyjd04vDS564sdG==",
    "payment_amount": 93.2,
    "order_options_flags": "",
    "order_status": "",
    "order_items": [
      {
        "client_sku": "NHK1480",
        "quantity": 2,
        "price": 23.0,
        "tax": 1.8,
        "other_adjustments": 0.0,
        "order_item_amount": 2.0,
        "order_item_options_flags": "backorder"
      },
      {
        "client_sku": "AKT5687",
        "quantity": 1,
        "shipping_weight_unit": "oz",
        "price": 64.0,
        "tax": 4.6,
        "other_adjustments": -2.0,
        "order_item_amount": 1.0,
        "order_item_options_flags": "backorder"
      }
    ]
  }
}

```


## Returns

todo

## Other Comments
