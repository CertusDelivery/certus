class Product < ActiveRecord::Base
  include ModelInLocation

  belongs_to :category
  belongs_to :location

  validates_presence_of :name, :store_sku
  validates_uniqueness_of :store_sku

  validates_numericality_of :price, :reg_price, greater_than: 0, :allow_blank => true
  validates_format_of :price, :reg_price, :with => /\A\d+(\.{1}\d{1,2})?\z/, :allow_blank => true
  
  STOCK_STATUS = { in_stock: 'IN_STOCK', out_of_stock: 'OUT_OF_STOCK' }

  def self.search(search, page)
    paginate :per_page => 10, :page => page, :conditions => ["name like ? or store_sku = ?", "%#{search}%", "#{search}"]
  end

  def self.relocation(store_sku, location_id)
    begin
      if store_sku.present? && location_id.present?
        product = Product.where(store_sku: store_sku).first
        product.location_id = location_id
        product.stock_status = Product::STOCK_STATUS[:in_stock]
        product.save!
        product
      else
        nil
      end
    rescue
      nil
    end
  end
end
