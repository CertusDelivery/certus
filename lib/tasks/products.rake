require 'csv'

namespace :products do
  
  desc "Import product data from csv file (options: FILE=/path/to/csv/file.csv)"
  task import_from_csv: :environment do
    begin
      # params validation
      raise "Please specify a csv file! (eg: FILE=/path/to/csv/file.csv)" unless ENV.include? 'FILE'

      file_path = File.expand_path ENV['FILE']
      raise "File (#{ENV['FILE']}) not exsit!" unless File.exist? file_path

      # repare logger
      log_path = Rails.root.join('log', 'products')
      Dir.mkdir log_path unless File.exist? log_path 
      csv = CSV.open("#{log_path}/#{Time.new.strftime("%Y%m%d%H%M%S")}_import_from_csv_log.csv", "wb")
      csv << ['type','time','message']

      # import data from cvs file
      pid = nil # print pid when import failse
      count = 0;
      puts "Importing the data of product from csv file..."
      Product.transaction do
        CSV.foreach(file_path, :headers => true) do |row|
          pid =  row['pid']
          count += 1
          product = Product.find_by_store_sku(row['sku/upc'])
          product ||= Product.new
          
          product.source = Product::SOURCE[:import]
          product.import = true
          product.store_sku = row['sku/upc']
          product.name = row['name'] || 'UNDEFINED'
          product.brand = row['brand']
          product.size = row['size1']
          product.image = row['image']
          product.sale_qty_min = row['sale qty min']
          product.sale_qty_limit = row['sale qty limit']
          product.info_1 = row['more info 1']
          product.info_2 = row['more info 2']

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

          product.category = Category.create_by_string(row['category']) 
          product.save!
          csv << ['I', Time.now.strftime("%Y-%m-%d %H:%M:%S %L"), "`#{product.name}` created successfully"] 
        end
        puts "Import Succseefully!!!"
        csv << ['I', Time.now.strftime("%Y-%m-%d %H:%M:%S %L"), "Import Successfully, Counts: #{count} "] 
      end
    rescue Exception => ex
      csv << ["F", Time.now.strftime("%Y-%m-%d %H:%M:%S %L"), "*** ##{pid}  #{ex.message}"] if csv
      puts "*** ##{pid}  #{ex.message}"
      puts "Rollback!"
    ensure
      csv.close if csv
    end
  end

end
