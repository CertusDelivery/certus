require 'float_ext'
require 'digest/md5'

class Product < ActiveRecord::Base
  include ModelInLocation

  belongs_to :category
  belongs_to :location

  validates_presence_of :name, :store_sku
  validates_uniqueness_of :store_sku

  validates_numericality_of :price, :reg_price, greater_than: 0, :allow_blank => true
  validates_inclusion_of :source, in: %w(NORMAL IMPORT)

  STOCK_STATUS = { in_stock: 'IN_STOCK', out_of_stock: 'OUT_OF_STOCK' }
  SOURCE       = { normal: 'NORMAL', import: 'IMPORT' }

  attr_accessor :import

  before_create :upload_image_to_s3
  before_save :format_price
  before_save :propagate_to_client
  before_destroy :propagate_to_client_on_destroy

  attr_accessor :location_info
  attr_accessor :location_info_temp
  def location_info=(value)
    #TODO: validate 
    if value.present?
      info = Product.generate_location_info(value)
      if info
        self.location = Location.find_by_info(info) || Location.create_by_info(info)
      else
        errors.add(:location, "format is invalid")
      end
    end
    self.location_info_temp = value
  end

  def location_info
    self.location ? self.location.info : self.location_info_temp
  end

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

  def self.import(row)
    pid =  row['pid']
    product = Product.find_by_store_sku(row['sku/upc'])
    product ||= Product.new
    
    product.source = Product::SOURCE[:import]
    product.store_sku = row['sku/upc']
    product.name = row['name'] || 'UNDEFINED'
    product.brand = row['brand']
    product.section = row['Custom Category - Section']
    product.department = row['Department']
    product.size = row['size1']
    product.size3 = row['size3']
    product.image = row['image']
    product.sale_qty_min = row['sale qty min']
    product.sale_qty_limit = row['sale qty limit']
    product.info_1 = row['more info 1']
    product.info_2 = row['more info 2']
    product.stock_status = row['stock status']
    product.on_sale = row['on_sale']

    if row['unit price']
      unit_price = row['unit price'].delete('$').split('/') if row['unit price']
      product.unit_price = unit_price[0]
      product.unit_price_unit = unit_price[1]
    end

    if row['sale price']
      product.price = row['sale price'].delete('$')
    end

    if row['reg price']
      product.reg_price = row['reg price'].delete('$')
    end

    if row['size2']
      weight = row['size2'].split(' ', 2)
      product.shipping_weight = weight[0]
      product.shipping_weight_unit = weight[1]
    end

    if row['location']
      product.location = Location.create_by_info(row['location'])
    end

    product.category = Category.create_by_string(row['category']) 
    product.save!
  end

  def out_of_stock!
    self.update_attributes(stock_status: STOCK_STATUS[:out_of_stock])
  end

  def upload_image_to_s3
    if self.image.present?
      filename = "#{Digest::SHA2.hexdigest("#{self.image}")}.#{self.image.split('.').last}"
      unless AWS::S3::S3Object.exists? filename, Setting.S3_bucket
        AWS::S3::S3Object.store(filename, open(self.image), Setting.S3_bucket) 
      end
      doomsday = Time.mktime(2035, 1, 1).to_i
      self.image = AWS::S3::S3Object.url_for(filename, Setting.S3_bucket, :expires => doomsday)
    end
  end

  def format_price
    self.price = self.price.to_f.round_down(2) unless self.price.blank?
    self.reg_price = self.reg_price.to_f.round_down(2) unless self.reg_price.blank? 
  end

  def build_log_info(action)
    info = {action => self.attributes.slice('store_sku', 'name', 'price', 'reg_price', 'stock_status', 'on_sale')}
    if action == 'update'
      info['origin'] = changed_attributes()
    end
    info.to_s
  end

  def propagate_to_client_on_destroy
    propagate_to_client(true)
  end

  def propagate_to_client(is_destroy = false)
    unless self.import
      options = {
        body: {
          token: '43edc126236f331d578f74ac55fc34259bcd832b',
          sku: self.store_sku,
          action: (is_destroy ? 'destroy' : (self.new_record? ? 'create' : 'update'))
        },
        headers: {
          referer: "http://#{APP_CONFIG[:domain]}"
        }
      }
      if self.new_record? || is_destroy || (stock_status_changed? || name_changed? || price_changed? || reg_price_changed? || on_sale_changed? || image_changed?)
        options[:body].merge!(self.attributes.slice('name', 'price', 'reg_price', 'stock_status', 'on_sale', 'image'))
        logger = Logger.new(Rails.root.join('log/typhoeus.log'))
        begin
          logger.info "--------------BEGIN--------"
          logger.info "Action: #{options[:body][:action]}"
          logger.info "URL: #{"http://#{APP_CONFIG[:web_shop]}/wc-api.php"}"
          response = Typhoeus::Request.post("http://#{APP_CONFIG[:web_shop]}/wc-api.php", options)
          logger.info "Success: #{response.success?}  Code: #{response.code}"
          logger.info "Response: #{response.inspect}" unless response.success?
          logger.info "--------------END----------"
          Log.record(model: Log::MODEL[:product], action: options[:body][:action], url: "http://#{APP_CONFIG[:web_shop]}/wc-api.php", success: response.success?, code: response.code, info: self.build_log_info(options[:body][:action]), response: response.body)
        rescue => e
          logger.error "Exception: #{e.inspect}"
        end
      end
    end
  end
end
