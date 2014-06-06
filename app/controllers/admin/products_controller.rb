require 'csv'
module Admin
  class ProductsController < AdminController
    include ActionController::Live

    def create
      begin
        require 'fileutils' 
        tmp = params[:file]
        file_ext = tmp.original_filename.split('.').last
        raise "This file is not a CSV!" unless file_ext == 'csv'
        file_name = "#{Time.new.strftime("%Y%m%d%H%M%S")}.#{file_ext}"
        file = File.join('public', 'uploads', 'products', file_name)
        FileUtils.cp tmp.path, file
        size  = CSV.readlines(file, :headers => true, encoding: "ISO8859-1").size
        if size > Setting.max_size_to_show_progress_bar
          AsyncImportWorker.perform_async(:import_products, Rails.root.join(file))
          flash[:notice] = "Start Import..."
        else
          CSV.foreach(file, :headers => true, encoding: "ISO8859-1") do |row|
            Product.import(row)
          end
          flash[:success] = "Import Successfully"
        end
      rescue Exception => ex
        flash[:alert] = ex.message
      end
      redirect_to :action => 'csv_import', :file => Rails.root.join(file)
    end
    
    def delete
      begin
        require 'fileutils' 
        tmp = params[:file]
        file_ext = tmp.original_filename.split('.').last
        raise "This file is not a CSV!" unless file_ext == 'csv'
        file_name = "#{Time.new.strftime("%Y%m%d%H%M%S")}.#{file_ext}"
        file = File.join('public', 'uploads', 'products', file_name)
        FileUtils.cp tmp.path, file
        size  = CSV.readlines(file, :headers => true, encoding: "ISO8859-1").size
        if size > Setting.max_size_to_show_progress_bar
          AsyncImportWorker.perform_async(:delete_products, Rails.root.join(file))
          flash[:notice] = "Start Delete..."
        else
          CSV.foreach(file, :headers => true, encoding: "ISO8859-1") do |row|
            if row['sku/upc']
              p = Product.where(store_sku: row['sku/upc']).first
              p.destroy if p
            end
          end
          flash[:success] = "Delete Successfully"
        end
      rescue Exception => ex
        flash[:alert] = ex.message
      end
      redirect_to :action => 'csv_delete', :file => Rails.root.join(file)
    end
    def csv_export
      products = Product.all.includes(:location)
      response.headers["Content-Type"] ||= 'text/event-stream'  
      response.headers["Content-Disposition"] = "attachment; filename=#{Time.new.strftime('%Y%m%d%H%M%S')}-products.csv"
      response.headers["Content-Transfer-Encoding"] = "binary"
      response.stream.write ['pid', 'Custom Category - Section', 'Department', 'category', 'brand', 'name', 'size1', 'size2', 'size3', 'sku/upc', 'reg price', 'unit price', 'sale price', 'sale qty min', 'sale qty limit', 'image', 'unit variables', 'more info 1', 'more info 2', 'location'].to_csv
      products.each do |p|
        response.stream.write [p.id, p.section, p.department, Category.get_category_string(p.category), p.brand, p.name, p.size, "#{p.shipping_weight} #{p.shipping_weight_unit}", p.size3, p.store_sku, "$#{p.reg_price}", "$#{p.unit_price}/#{p.unit_price_unit}", "$#{p.price}", p.sale_qty_min, p.sale_qty_limit, p.image, p.info_1, p.info_2, (p.location ? p.location.info : '')].to_csv
      end
    ensure
      response.stream.close
    end
  end
end
