# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140314084711) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deliveries", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "picker_id"
    t.string   "picked_status"
    t.integer  "picked_sku_count"
    t.integer  "picked_piece_count"
    t.decimal  "total_shipping_weight"
    t.decimal  "total_payment_adjustment"
    t.string   "bin_geocode"
    t.datetime "picked_at"
    t.datetime "left_store_at"
    t.integer  "hub_driver_id"
    t.integer  "route_driver_id"
    t.datetime "route_driver_received_at"
    t.string   "delivered_status"
    t.string   "message_status"
    t.string   "gratuity_status"
    t.datetime "delivered_at"
    t.integer  "client_id"
    t.integer  "store_id"
    t.integer  "order_id"
    t.integer  "order_sku_count"
    t.integer  "order_piece_count"
    t.decimal  "order_total_price"
    t.decimal  "order_total_tax"
    t.decimal  "order_total_adjustments"
    t.decimal  "order_non_apportionable_adjustments"
    t.integer  "order_grand_total"
    t.string   "order_flag"
    t.string   "order_status"
    t.integer  "payment_id"
    t.string   "payment_card_token"
    t.decimal  "payment_amount"
    t.datetime "placed_at"
    t.datetime "desired_delivery_window"
    t.string   "customer_name"
    t.string   "shipping_address"
    t.string   "customer_email"
  end

  create_table "delivery_items", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "store_sku"
    t.text     "location"
    t.integer  "picked_quantity"
    t.string   "picked_status"
    t.string   "substitute_sku"
    t.datetime "picked_datetime"
    t.decimal  "shipping_weight"
    t.string   "picker_bin_number"
    t.string   "payment_adjustment"
    t.text     "additional"
    t.integer  "delivery_id"
    t.string   "product_name"
    t.string   "client_slu"
    t.decimal  "quantity"
    t.decimal  "price"
    t.decimal  "tax"
    t.text     "other_adjustments"
    t.decimal  "order_item_amount"
    t.string   "order_item_options_flags"
    t.string   "shipping_weight_unit"
  end

end
