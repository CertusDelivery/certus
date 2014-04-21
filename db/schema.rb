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

ActiveRecord::Schema.define(version: 20140421022922) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "parent_id",  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deliveries", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "picker_id"
    t.string   "picked_status"
    t.integer  "picked_sku_count"
    t.integer  "picked_piece_count"
    t.decimal  "total_shipping_weight"
    t.decimal  "total_payment_adjustment"
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
    t.decimal  "order_grand_total"
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
    t.string   "customer_phone_number"
    t.string   "lat"
    t.string   "lng"
  end

  create_table "delivery_items", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "store_sku"
    t.integer  "picked_quantity",          default: 0
    t.string   "picked_status"
    t.string   "substitute_sku"
    t.datetime "picked_datetime"
    t.decimal  "shipping_weight"
    t.string   "picker_bin_number"
    t.string   "payment_adjustment"
    t.text     "additional"
    t.integer  "delivery_id"
    t.string   "product_name"
    t.string   "client_sku"
    t.integer  "quantity"
    t.decimal  "price"
    t.decimal  "tax"
    t.text     "other_adjustments"
    t.decimal  "order_item_amount"
    t.string   "order_item_options_flags"
    t.string   "shipping_weight_unit"
    t.integer  "out_of_stock_quantity",    default: 0
    t.integer  "scanned_quantity",         default: 0
    t.boolean  "is_replaced",              default: false
  end

  create_table "locations", force: true do |t|
    t.string  "info"
    t.string  "aisle"
    t.string  "direction"
    t.integer "distance"
    t.integer "shelf"
  end

  add_index "locations", ["info"], name: "index_locations_on_info", unique: true, using: :btree

  create_table "products", force: true do |t|
    t.string   "name",                                      null: false
    t.string   "store_sku",                                 null: false
    t.decimal  "shipping_weight"
    t.string   "shipping_weight_unit"
    t.decimal  "adjustment"
    t.decimal  "price"
    t.boolean  "taxable"
    t.decimal  "tax_rate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stock_status",         default: "IN_STOCK"
    t.integer  "category_id"
    t.decimal  "reg_price"
    t.decimal  "unit_price"
    t.string   "unit_price_unit"
    t.integer  "sale_qty_min"
    t.integer  "sale_qty_limit"
    t.text     "size"
    t.string   "brand"
    t.string   "image"
    t.text     "info_1"
    t.text     "info_2"
    t.boolean  "on_sale",              default: true
    t.integer  "location_id"
  end

end
