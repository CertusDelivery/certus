require 'eventmachine'
class AsyncImportWorker
  include Sidekiq::Worker

  def perform(job, condition)
    begin
      self.method(job).call condition
    rescue
      logger = get_logger
      logger.fatal "undefined method '#{job}'"
    end
  end

  def import_products(file)
    logger = get_logger
    begin
      count   = 1
      size  = CSV.readlines(file["path"], :headers => true, encoding: "ISO8859-1").size
      param = {count: 0, size: size, persent: 0, finished: false, file: file["path"]}
      FayeClient.send('/import/products', param)
      CSV.foreach(file["path"], :headers => true, encoding: "ISO8859-1") do |row|
        begin
          Product.import(row)
        rescue => e
          logger.fatal "raised unrecoverable error!!!  #{e.message} (pid #{row['pid']})"
        end
        param = {count: count, size: size, persent: ((count*1.0/size)*100).to_i, finished: count == size, file: file["path"]}
        FayeClient.send('/import/products', param)
        count += 1
      end
    rescue => e
      logger.fatal "raised unrecoverable error!!!  #{e.message} (file #{file})"
    end
  end

  def delete_products(file)
    begin
      count   = 1
      size  = CSV.readlines(file["path"], :headers => true, encoding: "ISO8859-1").size
      param = {count: 0, size: size, persent: 0, finished: false, file: file["path"]}
      FayeClient.send('/delete/products', param)
      Product.transaction do
        CSV.foreach(file["path"], :headers => true, encoding: "ISO8859-1") do |row|
          if row['sku/upc']
            p = Product.where(store_sku: row['sku/upc']).first
            p.destroy if p
          end
          param = {count: count, size: size, persent: ((count*1.0/size)*100).to_i, finished: count == size, file: file["path"]}
          FayeClient.send('/delete/products', param)
          count += 1
        end
      end
    rescue => e
      logger = get_logger
      logger.fatal "raised unrecoverable error!!!  #{e.message} (file #{file})"
    end
  end

  def export_products(key)
    begin
      products  = Product.all.includes(:location, :category)
      size      = products.size
      tmp_path  = Rails.root.join('public', 'tmp')
      Dir.mkdir tmp_path unless File.exist? tmp_path 
      file_path = "#{tmp_path}/#{key}-products.csv"
      file_name = "/tmp/#{key}-products.csv"
      return if File.exist? file_path
      CSV.open(file_path, "wb") do |csv|
        csv << ['pid', 'Custom Category - Section', 'Department', 'category', 'brand', 'name', 'size1', 'size2', 'size3', 'sku/upc', 'reg price', 'unit price', 'sale price', 'sale qty min', 'sale qty limit', 'image', 'unit variables', 'more info 1', 'more info 2', 'location', 'stock status', 'on sale']
        products.each_with_index do |p,i|
          csv << [p.id, p.section, p.department, Category.get_category_string(p.category), p.brand, p.name, p.size, "#{p.shipping_weight} #{p.shipping_weight_unit}", p.size3, p.store_sku, "$#{p.reg_price}", "$#{p.unit_price}/#{p.unit_price_unit}", "$#{p.price}", p.sale_qty_min, p.sale_qty_limit, p.image, p.info_1, p.info_2, (p.location ? p.location.info : ''), p.stock_status, p.on_sale]
          param = {count: i+1, size: size, persent: (((i+1)*1.0/size)*100).to_i, finished: i+1 == size, file: file_name, key: key}
          FayeClient.send('/export/products', param)
        end
      end
    rescue => e
      logger = get_logger
      logger.fatal "raised unrecoverable error!!!  #{e.message} (file #{file})"
    ensure
      csv.close if csv
    end
  end

  def get_logger
    worker_logfile = File.open("#{Rails.root}/log/async_import_worker.log", 'a')
    worker_logfile.sync = true
    Logger.new(worker_logfile)
  end
end
