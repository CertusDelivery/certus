require 'csv'

namespace :products do
  
  desc "Import product data from csv file (options: FILE=/path/to/csv/file.csv [SYN=(yes|no)]),if you want to synchronize product data between workflow and webshop, just set SYN to yes"
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
      count = 0
      error = 0
      syn_flag = ENV['SYN'] == 'yes' ? false : true
      puts "Importing the data of product from csv file..."
      @current_procent = 0
      @line_number = 0
      @total_line_count = (`wc -l #{file_path}`[/\d+/]).to_f
      CSV.foreach(file_path, :headers => true, encoding: "ISO8859-1") do |row|
        pid =  row['pid']
        count += 1
        begin
          Product.import row
          #csv << ['I', Time.now.strftime("%Y-%m-%d %H:%M:%S %L"), "`#{row['name']}` created successfully"] 
        rescue Exception => ex
          csv << ["F", Time.now.strftime("%Y-%m-%d %H:%M:%S %L"), "*** ##{pid}  #{ex.message}"] if csv
          error += 1
        end
        display_progress
      end
      puts "\r\nImport Succseefully!!!"
      csv << ['I', Time.now.strftime("%Y-%m-%d %H:%M:%S %L"), "Import Successfully, Success: #{count-error} Error: #{error} "] 
    rescue Exception => ex
      puts "*** #{ex.message}"
      puts "Rollback!"
    ensure
      csv.close if csv
    end
  end

  def display_progress
    @line_number += 1
    procent = ((@line_number/@total_line_count)*100.0).round
    print "\r\e[O #{procent}%" if @current_procent != procent
    @current_procent = procent
    $stdout.flush
  end

end
