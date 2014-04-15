class Product < ActiveRecord::Base
  belongs_to :category

  STOCK_STATUS = { in_stock: 'IN_STOCK', out_of_stock: 'OUT_OF_STOCK' }


  def self.search(search, page)
    paginate :per_page => 10, :page => page, :conditions => ["name like ? or store_sku = ?", "%#{search}%", "#{search}"]
  end
end
