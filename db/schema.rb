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
  end

end
