json.product_name @product.name
json.client_sku @product.store_sku
json.(@product, :store_sku, :price)
json.tax @product.taxable ? (@product.price * @product.tax_rate).round(2) : 0
json.other_adjustments @product.adjustment
