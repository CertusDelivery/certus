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
    begin
      count   = 1
      size  = CSV.readlines(file["path"], :headers => true).size
      Product.transaction do
        CSV.foreach(file["path"], :headers => true) do |row|
          Product.import(row)
          param = {count: count, size: size, persent: ((count*1.0/size)*100).to_i, finished: count == size, file: file["path"]}
          FayeClient.send('/import/products', param)
          count += 1
        end
      end
    rescue => e
      logger = get_logger
      logger.fatal "raised unrecoverable error!!!  #{e.message} (file #{file})"
    end
  end

  def get_logger
    worker_logfile = File.open("#{Rails.root}/log/async_import_worker.log", 'a')
    worker_logfile.sync = true
    Logger.new(worker_logfile)
  end
end
