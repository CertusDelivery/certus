require 'digest/md5'
require 'time_ext'
class Delivery < ActiveRecord::Base

  MAX_PICKING_COUNT = 3

  PICKED_STATUS = {
    unassigned:     'UNASSIGNED',
    unpicked:       'UNPICKED',
    picking:        'PICKING',
    picked:         'PICKED',
    store_staging:  'STORE_STAGING'
  }

  MESSAGE_STATUS = {
    received:         'RECEIVED',
    picked:           'PICKED',
    out_for_delivery: 'OUT_FOR_DELIVERY',
    arrive_soon:      'ARRIVE_SOON',
    delivered:        'DELIVERED'
  }

  ORDER_FLAGS = {
    substitute: 'SUBSTITUTE',
    backorder:  'BACKORDER',
    critical:   'CRITICAL',
    skip:       'SKIP'
  }

  DELIVERY_OPTIONS = {
    doorstep_delivery:        'DOORSTEP_DELIVERY',
    kitchen_counter_delivery: 'KITCHEN_COUNTER_DELIVERY',
    doorstep_if_no_one_home:  'DOORSTEP_IF_NO_ONE_HOME'
  }
  
  has_many :delivery_picker_ships
  has_many :pickers, through: :delivery_picker_ships
  has_many :delivery_items do
    def all_picked?
      collect do |item|
        return false unless item.picked?
      end
      true
    end
  end
  belongs_to :router, class_name: 'User', foreign_key: 'router_id'

  attr_accessor :flash_notice
  geocoded_by :shipping_address

  scope :fifo, -> {order(id: :asc)}
  scope :unpicked, -> { where(picked_status: PICKED_STATUS[:unpicked]) }
  scope :pickable, lambda{|user| where("picked_status=? or picked_status=?", PICKED_STATUS[:unpicked], PICKED_STATUS[:picking]).where.not(id: user.deliveries.map(&:id))}
  scope :picking, -> { where(picked_status: PICKED_STATUS[:picking]) }
  #router
  scope :unroute, -> { where(picked_status: PICKED_STATUS[:store_staging], message_status: MESSAGE_STATUS[:picked], router_id: nil)}
  #customer
  validates_presence_of :customer_name, :shipping_address, :customer_email
  validates_format_of :customer_email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :message => 'customer email must be valid'
  #order
  validates_presence_of :order_id, :placed_at, :order_sku_count, :order_piece_count, :order_total_price, :client_id
  validates_uniqueness_of :order_id, allow_nil: false, scope: [:client_id]
  validates_numericality_of :order_piece_count, greater_than: 0
  #payment
  validates_presence_of :payment_id, :payment_amount, :payment_card_token
  #delivery_items
  validates_associated :delivery_items
  validate :order_to_delivery_convert

  accepts_nested_attributes_for :delivery_items

  # callbacks .................................................................
  after_validation :geocode, :if => :shipping_address_changed?
  before_create :initial_secure_salt, :initial_delivery_window, :setup_status
  before_update :change_order_items_options_flags, :if => :order_flag_changed?
  before_update :add_msg_into_flash, :if => :delivery_option_changed?
  after_update :publish_items_for_faye, :if => :picked_status_changed?

  # class methods .............................................................

  class << self
    def complete_all_for_user(user)
      picked_orders = user.deliveries.picking.includes(:delivery_items).select{|d| d.can_be_complete? }
      picked_orders.each(&:complete!)
      message = case picked_orders.size
      when 0
        "No order have been completed picked."
      when 1
        "1 order have been removed from the list."
      else
        "#{picked_orders.size} orders have been removed from the list."
      end
    end
  end

  # public instance methods ...................................................
  PICKED_STATUS.each do |k, v|
    define_method "#{k}?" do
      picked_status == v
    end
  end

  def can_be_complete?
    delivery_items.all_picked?
  end

  def complete!
    if can_be_complete?
      self.update_attributes({ picked_status: PICKED_STATUS[:store_staging], message_status: MESSAGE_STATUS[:picked]})
      AsyncMailWorker.perform_async(:delivery, self.id)
    end
  end

  def out_for_delivery(user)
    if user
      self.update_attributes({message_status: MESSAGE_STATUS[:out_for_delivery], router_id: user.id})
      AsyncMailWorker.perform_async(:delivery, self.id)
    end
  end

  def picked_total_price
    delivery_items.inject(0) { |sum, item| sum += item.picked_total_price }
  end

  def quantity
    delivery_items.inject(0) { |sum, item| sum += item.quantity }
  end

  def picked_quantity
    delivery_items.inject(0) { |sum, item| sum += item.picked_quantity }
  end

  def out_of_stock_quantity 
    delivery_items.inject(0) { |sum, item| sum += item.out_of_stock_quantity }
  end

  def expected_delivery_window
    "#{(placed_at+3.hours).round_off(30.minutes).strftime("%Y-%m-%d %H:%M %p")} - #{(placed_at+4.hours).round_off(30.minutes).strftime("%H:%M %p")}"
  end

  # protected instance methods ................................................
  protected

  def initial_delivery_window
    self.desired_delivery_window = DateTime.current + 6.hours unless self.desired_delivery_window
  end

  def initial_secure_salt
    self.secure_salt = SecureRandom.hex(10)
    self.secure_order_id  = Digest::SHA2.hexdigest("#{self.order_id}#{self.secure_salt}")
  end

  def setup_status
    self.picked_status = PICKED_STATUS[:unpicked] unless self.picked_status
    self.message_status = MESSAGE_STATUS[:received]
  end

  def order_to_delivery_convert
    if order_grand_total != payment_amount
      self.errors.add(:order_grand_total,"order_grand_total doesn't match payment_amount")
    end

    ##
    # Comment off the validation for now.
    # TODO: 1. We need to handle order total price and order SKU count changes when products has been replaced by other products.

    # if order_sku_count != delivery_items.size()
    #   self.errors.add(:order_sku_count,"sku_count doesn't match number of order_items")
    # end
    # #Total Price must equal the sum of all order_item. price values
    # if order_total_price != delivery_items.to_a.sum(&:total_price)
    #   self.errors.add(:order_total_price,"total price doesn't match the sum of all order_items price")
    # end
  end

  def change_order_items_options_flags
    self.delivery_items.update_all(order_item_options_flags: self.order_flag)
  end

  def add_msg_into_flash
    self.flash_notice = "Your driver will be notified of any changes you make to the delivery option for your order." 
  end

  def publish_items_for_faye
    if self.store_staging?
      AsyncFayeWorker.perform_async(:delivery_picked, self.id)
    end
  end
end
