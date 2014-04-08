class Product < ActiveRecord::Base
  belongs_to :category

  STOCK_STATUS = { in_stock: 'IN_STOCK', out_of_stock: 'OUT_OF_STOCK' }
end
