require 'csv'
module Admin
  class ProductsController < AdminController
    def import
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
      redirect_to :action => 'import', :file => Rails.root.join(file)
    end
  end
  def none
  end
end
