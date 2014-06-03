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
      
        count = 1
        Product.transaction do
          CSV.foreach(file, :headers => true) do |row|
            count += 1
            Product.import(row)
          end
        end
        flash[:notice] = "Import Successfully, Counts: #{count}"
      rescue Exception => ex
        flash[:alert] = ex.message
      end
      redirect_to :action => 'import'
    end
  end
end
