require 'csv'
module Admin
  class ProductsController < AdminController
    def csv_import
    end

    def create
      begin
        require 'fileutils' 
        tmp = params[:file]
        file_ext = tmp.original_filename.split('.').last
        raise "This file is not a CSV!" unless file_ext == 'csv'
        file_name = "#{Time.new.strftime("%Y%m%d%H%M%S")}.#{file_ext}"
        file = File.join('public', 'uploads', 'products', "#{file_name}")
        FileUtils.cp tmp.path, file
        size  = CSV.readlines(file, :headers => true).size
        if size > Setting.max_size_to_show_progress_bar
          AsyncImportWorker.perform_async(:import_products, Rails.root.join(file))
          flash[:notice] = "Start Import..."
        else
          CSV.foreach(file, :headers => true) do |row|
            Product.import(row)
          end
          flash[:success] = "Import Successfully"
        end
      rescue Exception => ex
        flash[:alert] = ex.message
      end
      redirect_to :action => 'csv_import', :file => Rails.root.join(file)
    end
    
    def csv_export
      products = Product.all
      csv_string = CSV.generate do |csv|
        csv << ['pid', 'category', 'brand', 'name', 'size1', 'size2', 'sku/upc', 'reg price', 'unit price', 'sale price', 'sale qty min', 'sale qty limit', 'image', 'unit variables', 'more info 1', 'more info 2']
        products.each do |p|
          csv << [p.id, p.category, p.brand, p.name, p.size, "#{p.shipping_weight} #{p.shipping_weight_unit}", p.store_sku, "$#{p.reg_price}", "$#{p.unit_price}/#{p.unit_price_unit}", "$#{p.price}", p.sale_qty_min, p.sale_qty_limit, p.image, p.info_1, p.info_2]
        end
      end
      send_data csv_string,  
                :type=>'text/csv; charset=iso-8859-1; header=present',  
                :disposition => "attachment; filename=#{Time.new.strftime('%Y%m%d%H%M%S')}-products.csv"
    end
  end
end
