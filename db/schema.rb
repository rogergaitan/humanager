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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121001204531) do

  create_table "addresses", :force => true do |t|
    t.string   "address"
    t.integer  "entity_id"
    t.integer  "province_id"
    t.integer  "canton_id"
    t.integer  "district_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "addresses", ["canton_id"], :name => "index_addresses_on_canton_id"
  add_index "addresses", ["district_id"], :name => "index_addresses_on_district_id"
  add_index "addresses", ["entity_id"], :name => "index_addresses_on_entity_id"
  add_index "addresses", ["province_id"], :name => "index_addresses_on_province_id"

  create_table "bank_accounts", :force => true do |t|
    t.string   "bank"
    t.string   "bank_account"
    t.string   "sinpe"
    t.string   "account_title"
    t.integer  "entity_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "bank_accounts", ["entity_id"], :name => "index_bank_accounts_on_entity_id"

  create_table "cantons", :force => true do |t|
    t.string   "canton"
    t.integer  "province_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "cantons", ["province_id"], :name => "index_cantons_on_province_id"

  create_table "categories", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "occupation"
    t.string   "phone"
    t.string   "email"
    t.string   "skype"
    t.integer  "entity_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "contacts", ["entity_id"], :name => "index_contacts_on_entity_id"

  create_table "districts", :force => true do |t|
    t.string   "district"
    t.integer  "canton_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "districts", ["canton_id"], :name => "index_districts_on_canton_id"

  create_table "emails", :force => true do |t|
    t.string   "email_type"
    t.string   "email"
    t.integer  "entity_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "emails", ["entity_id"], :name => "index_emails_on_entity_id"

  create_table "entities", :force => true do |t|
    t.string   "name"
    t.string   "surname"
    t.integer  "entityid"
    t.enum     "typeid",     :limit => [:nacional, :extrangero, :juridico]
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
  end

  create_table "lines", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "description"
    t.integer  "inventory"
    t.integer  "sale_cost"
    t.integer  "utility_adjusment"
    t.integer  "lost_adjustment"
    t.integer  "income"
    t.integer  "sales_return"
    t.integer  "purchase_return"
    t.integer  "sale_tax"
    t.integer  "purchase_tax"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "phones", :force => true do |t|
    t.string   "phone_type"
    t.string   "phone"
    t.integer  "entity_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "phones", ["entity_id"], :name => "index_phones_on_entity_id"

  create_table "product_pricings", :force => true do |t|
    t.integer  "product_id"
    t.float    "utility"
    t.enum     "price_type", :limit => [:other, :credit, :cash]
    t.enum     "category",   :limit => [:a, :b, :c]
    t.float    "sell_price"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "code"
    t.integer  "line_id"
    t.integer  "subline_id"
    t.integer  "category_id"
    t.string   "part_number"
    t.string   "name"
    t.string   "make"
    t.string   "model"
    t.string   "year"
    t.string   "version"
    t.integer  "max_discount"
    t.string   "address"
    t.integer  "max_cant"
    t.integer  "min_cant"
    t.float    "cost"
    t.string   "bar_code"
    t.integer  "market_price"
    t.enum     "status",       :limit => [:active, :inactive, :out_of_stock]
    t.integer  "stock"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
  end

  create_table "provinces", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sublines", :force => true do |t|
    t.string   "code"
    t.string   "description"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "warehouses", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "description"
    t.string   "manager"
    t.string   "address"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
