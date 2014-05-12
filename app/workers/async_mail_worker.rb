class AsyncMailWorker
  include Sidekiq::Worker

  def perform(job, condition)
    begin
      self.method(job).call condition
    rescue
      logger = get_logger
      logger.fatal "undefined method '#{job}'"
    end
  end

  # when delivery status changed
  def delivery(id)
    logger = get_logger
    begin
      UserMailer.customer_notification(Delivery.find(id)).deliver
      logger.info "send an e-mail to the delivery #{id} successfully"
    rescue
      logger.fatal "raised unrecoverable error!!! (delivery #{id})"
    end
  end

  def get_logger
    worker_logfile = File.open("#{Rails.root}/log/async_mail_worker.log", 'a')
    worker_logfile.sync = true
    Logger.new(worker_logfile)
  end
end
