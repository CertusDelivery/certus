class Product < ActiveRecord::Base
  belongs_to :category

  validates_presence_of :name, :store_sku, :price
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :reg_price, greater_than: 0, :allow_blank => true
  
  validates_uniqueness_of :store_sku
  
  STOCK_STATUS = { in_stock: 'IN_STOCK', out_of_stock: 'OUT_OF_STOCK' }


  def self.search(search, page)
    paginate :per_page => 10, :page => page, :conditions => ["name like ? or store_sku = ?", "%#{search}%", "#{search}"]
  end
end
