require 'eventmachine'
class AsyncFayeWorker
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
  def delivery_picked(id)
    logger = get_logger
    begin
      FayeClient.send('/delivery/picked', Delivery.find(id).delivery_items)
      logger.info "publish '/delivery/picked' for the delivery #{id} successfully"
    rescue => e
      logger.fatal "raised unrecoverable error!!! #{e.message} (delivery #{id})"
    end
  end

  def delivery_item_updated(id)
    logger = get_logger
    begin
      FayeClient.send('/delivery_item/updated', DeliveryItem.find(id).as_hash)
      logger.info "publish '/delivery_item/updated' for the delivery item #{id} successfully"
    rescue => e
      logger.fatal "raised unrecoverable error!!! #{e.message} (delivery #{id})"
    end
  end

  def delivery_shared(id)
    logger = get_logger
    begin
      ship = DeliveryPickerShip.find(id)
      FayeClient.send('/delivery/shared', {picker_id: ship.picker_id, items: ship.delivery.delivery_items.map(&:as_hash)})
      logger.info "publish '/delivery/shared' for the delivery #{id} successfully"
    rescue => e
      logger.fatal "raised unrecoverable error!!!  #{e.message} (delivery #{id})"
    end
  end

  def get_logger
    worker_logfile = File.open("#{Rails.root}/log/async_faye_worker.log", 'a')
    worker_logfile.sync = true
    Logger.new(worker_logfile)
  end
end
