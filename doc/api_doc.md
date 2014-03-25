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
      <td>Customer's name</td>
    </tr>

    <tr>
      <td>shipping_address</td>
      <td>true</td>
      <td>String</td>
      <td>Full shipping address</td>
    </tr>

    <tr>
      <td>customer_phone_number</td>
      <td>false</td>
      <td>String</td>
      <td>Customer's phone number</td>
    </tr>

    <tr>
      <td>customer_email</td>
      <td>true</td>
      <td>String</td>
      <td>Customer's email</td>
    </tr>

    <tr>
      <td>placed_at</td>
      <td>true</td>
      <td>Datetime</td>
      <td>Order placed timestamp</td>
    </tr>

    <tr>
      <td>desired_delivery_window</td>
      <td>false</td>
      <td>Datetime</td>
      <td>Desired delivery time</td>
    </tr>

    <tr>
      <td>client_id</td>
      <td>true</td>
      <td>Integer</td>
      <td>ID of the owner of the website</td>
    </tr>

    <tr>
      <td>store_id</td>
      <td>true</td>
      <td>Integer</td>
      <td>ID of the store where delivery items are picked for fulfillment</td>
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
      <td>Decimal</td>
      <td>Order totals:	price</td>
    </tr>

    <tr>
      <td>order_total_tax</td>
      <td>false</td>
      <td>Decimal</td>
      <td>Order totals:	tax</td>
    </tr>

    <tr>
      <td>order_total_adjustments</td>
      <td>false</td>
      <td>Decimal</td>
      <td>Order totals:	adjustments, defaults to 0.0</td>
    </tr>

    <tr>
      <td>order_non_apportionable_adjustments</td>
      <td>false</td>
      <td>Decimal</td>
      <td>Order totals:	Non apportionable adjustments, defaults to 0.0</td>
    </tr>

    <tr>
      <td>order_grand_total</td>
      <td>true</td>
      <td>Decimal</td>
      <td>Order totals: Grand total</td>
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
      <td>Decimal</td>
      <td>Client payment amount</td>
    </tr>

    <tr>
      <td>order_flag</td>
      <td>false</td>
      <td>String</td>
      <td>Options for items if they are out of stock, it will overwrite order_item_options_flags for all delivery items.<br/>
          Available options: "SUBSTITUTE", "BACKORDER", "CRITICAL", "SKIP".
          SUBSTITUTE: Substitute item if out of stock,<br/>
          BACKORDER: Backorder item if out of stock and re-deliver when item is available,<br/>
          CRITICAL: Cancel order if item is out of stock,<br/>
          SKIP: Cancel this item only if out of stock<br/>
      </td>
    </tr>

    <tr>
      <td>order_status</td>
      <td>true</td>
      <td>String</td>
      <td>Should be "PLACED" in gerneral</td>
    </tr>

    <tr>
      <td>delivery_items_attributes</td>
      <td>true</td>
      <td>Array</td>
      <td>An array contains delivery items (order items) objects</td>
    </tr>
  </tbody>
</table>

### Delivery Item (Order Item)

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
      <td>Product code used on the client website</td>
    </tr>

    <tr>
      <td>quantity</td>
      <td>true</td>
      <td>Integer</td>
      <td>Quantity for the products in the individual order item</td>
    </tr>

    <tr>
      <td>shipping_weight_unit</td>
      <td>false</td>
      <td>String</td>
      <td>Needed if this product is not sold by piece, defaults to "ea". "oz", "gal" and "lb" are also allowed.</td>
    </tr>

    <tr>
      <td>price</td>
      <td>true</td>
      <td>Decimal</td>
      <td>Price per unit</td>
    </tr>

    <tr>
      <td>tax</td>
      <td>true</td>
      <td>Decimal</td>
      <td>Tax per unit</td>
    </tr>

    <tr>
      <td>other_adjustments</td>
      <td>false</td>
      <td>Text</td>
      <td>Adjustment for the individual order item, defaults to 0.0</td>
    </tr>

    <tr>
      <td>order_item_amount</td>
      <td>true</td>
      <td>Decimal</td>
      <td>Amount for the individual order item</td>
    </tr>

    <tr>
      <td>order_item_options_flags</td>
      <td>true</td>
      <td>String</td>
      <td>Available options: "SUBSTITUTE", "BACKORDER", "CRITICAL", "SKIP".<br/>
          SUBSTITUTE: Substitute item if out of stock,<br/>
          BACKORDER: Backorder item if out of stock and re-deliver when item is available,<br/>
          CRITICAL: Cancel order if item is out of stock,<br/>
          SKIP: Cancel this item only if out of stock<br/>
      </td>
    </tr>

  </tbody>
</table>


A sample of request parameters

```json
{
  "delivery":
  {
    "customer_name": "Jane Doe",
    "shipping_address": "204 Henderson Road, San Diego, CA 92124",
    "customer_phone_number": "626-780-7552",
    "customer_email": "jave1670@example.com",
    "order_placed_timestamp": "2014-04-09 11:20:25 UTC",
    "desired_deliverywindow": "2014-04-12",
    "client_id": 205697,
    "store_id": 9781,
    "client_internal_order_id": 6585395783,
    "sku_count": 3,
    "piece_count": 3,
    "total_price": 110.0,
    "total_tax": 8.2,
    "total_item_adjustments": -12.8,
    "non_apportionable_adjustments": 0.0,
    "grand_total": 105.4,
    "client_payment_id": 7256,
    "payment_card_token": "NSpyjd04vDS564sdG==",
    "payment_amount": 105.4,
    "order_options_flags": "",
    "order_status": "PLACED",
    "delivery_items_attributes": [
      {
        "client_sku": "NHK1480",
        "quantity": 2,
        "price": 23.0,
        "tax": 1.8,
        "other_adjustments": 0.0,
        "order_item_amount": 49.6,
        "order_item_options_flags": "backorder"
      },
      {
        "client_sku": "AKT5687",
        "quantity": 1,
        "shipping_weight_unit": "oz",
        "price": 64.0,
        "tax": 4.6,
        "other_adjustments": -2.0,
        "order_item_amount": 66.6,
        "order_item_options_flags": "backorder"
      }
    ]
  }
}

```


## Response

Data returned in the response message is provided in JSON format.

### Success

If there are no communications or other problems with the order, the Workflow server responds to the client website that the order is “IN_FULFILLMENT” and returns an estimated delivery window.

```json
{
  "status": "ok",
  "order":
  {
    "order_status": "IN_FULFILLMENT",
    "estimated_delivery_window": "2014-03-18 15:40:40 UTC, 120"
  }
}
```

### Error

Errors are returned as JSON objects that contain "status" and "reason" attributes. The value of the "status" attribute will always be "nok". The reason will be a short english string that describes the error.
Here are some generic error responses that you should be aware of.

<table>
  <thead>
    <tr>
      <td>Code</td>
      <td>Message</td>
      <td>Description</td>
    </tr>
  </thead>
  
  <tbody>
    <tr>
      <td>400</td>
      <td>Bad request.</td>
      <td>Invalid request format.</td>
    </tr>

    <tr>
      <td>401</td>
      <td>Unauthorized</td>
      <td>Authentication failed.</td>
    </tr>

    <tr>
      <td>422</td>
      <td>Invalid order.</td>
      <td>Data are incomplete or in the wrong format or information doesn't match.</td>
    </tr>

    <tr>
      <td>422</td>
      <td>Duplicated order.</td>
      <td>A request was made with duplicated data.</td>
    </tr>

    <tr>
      <td>422</td>
      <td>Shipping address not allowed.</td>
      <td>Shipping address is not in the allowable delivery area.</td>
    </tr>
  </tbody>
</table>

An example of error response

```
HTTP/1.1 422 Unprocessable Entity
<http headers>

{"status":"nok", "reason": "Invalid Order."}
```
