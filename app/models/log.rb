class Log < ActiveRecord::Base
  MODEL = { product: 'PRODUCT' }
  
  scope :products,     -> { where(model: MODEL[:product]) }
  scope :unsuccessful, -> { where(success: false) }
  scope :successful,   -> { where(success: true) }

  default_scope           { order('created_at desc') }

  class << self
    def record(params)
      log = Log.new(params)
      log.save
    end
  end
end
