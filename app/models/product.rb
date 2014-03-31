class Product < ActiveRecord::Base
  STOCK_STATUS = { in_stock: 'IN_STOCK', out_of_stock: 'OUT_OF_STOCK' }
end
