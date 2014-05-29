require 'float_ext'

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

  def out_of_stock!
    self.update_attributes(stock_status: STOCK_STATUS[:out_of_stock])
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
      if self.new_record? || is_destroy || (stock_status_changed? || name_changed? || price_changed? || reg_price_changed? || on_sale_changed?)
        options[:body].merge!(self.attributes.slice('name', 'price', 'reg_price', 'stock_status', 'on_sale'))
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
