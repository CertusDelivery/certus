class Product < ActiveRecord::Base
  include ModelInLocation

  belongs_to :category
  belongs_to :location

  validates_presence_of :name, :store_sku
  validates_uniqueness_of :store_sku

  validates_numericality_of :price, :reg_price, greater_than: 0, :allow_blank => true
  validates_format_of :price, :reg_price, :with => /\A\d+(\.{1}\d{1,2})?\z/, :allow_blank => true

  before_save :propagate_to_client
  
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

  def out_of_stock!
    self.update_attributes(stock_status: STOCK_STATUS[:out_of_stock])
  end

  def propagate_to_client
    options = {
      body: {
        token: '43edc126236f331d578f74ac55fc34259bcd832b',
        sku: self.store_sku
      }
    }
    if self.new_record?
      options[:body].merge!(self.attributes.slice('name', 'price', 'reg_price', 'stock_status', 'on_sale'))
    else
      options[:body][:stock_status] = self.stock_status if stock_status_changed?
    end
    logger = Logger.new(Rails.root.join('log/typhoeus.log'))
    begin
      logger.info "--------------start--------"
      logger.info "URL: #{"http://#{APP_CONFIG[:web_shop]}/wc-api.php"}"
      logger.info "Options: #{options.inspect}"
      Typhoeus::Request.post("http://#{APP_CONFIG[:web_shop]}/wc-api.php", options)
      logger.info "--------------end----------"
    rescue => e
      logger.error "Exception: #{e.inspect}"
    end
  end
end
