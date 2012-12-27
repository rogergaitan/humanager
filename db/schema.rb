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

ActiveRecord::Schema.define(:version => 20121226210810) do

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
    t.string   "name"
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

  create_table "customer_profiles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "customers", :force => true do |t|
    t.string   "asigned_seller"
    t.integer  "customer_profile_id"
    t.integer  "entity_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "customers", ["customer_profile_id"], :name => "index_customers_on_customer_profile_id"
  add_index "customers", ["entity_id"], :name => "index_customers_on_entity_id"

  create_table "deductions", :force => true do |t|
    t.string   "description"
    t.integer  "employee_id"
    t.string   "frequency"
    t.string   "calculation_method"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "deductions", ["employee_id"], :name => "index_deductions_on_employee_id"

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.integer  "employee_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "departments", ["employee_id"], :name => "index_departments_on_employee_id"

  create_table "districts", :force => true do |t|
    t.string   "name"
    t.integer  "canton_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "province_id"
  end

  add_index "districts", ["canton_id"], :name => "index_districts_on_canton_id"
  add_index "districts", ["province_id"], :name => "index_districts_on_province_id"

  create_table "emails", :force => true do |t|
    t.integer  "entity_id"
    t.string   "email"
    t.enum     "typeemail",  :limit => [:personal, :work]
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "emails", ["entity_id"], :name => "index_emails_on_entity_id"

  create_table "employees", :force => true do |t|
    t.integer  "entity_id"
    t.enum     "gender",               :limit => [:male, :female]
    t.date     "birthday"
    t.enum     "marital_status",       :limit => [:single, :married, :divorced, :widowed, :civil_union, :engage]
    t.integer  "number_of_dependents"
    t.string   "spouse"
    t.date     "join_date"
    t.string   "social_insurance"
    t.boolean  "ccss_calculated"
    t.integer  "department_id"
    t.integer  "occupation_id"
    t.integer  "role_id"
    t.boolean  "seller"
    t.integer  "payment_method_id"
    t.integer  "payment_frequency_id"
    t.integer  "means_of_payment_id"
    t.decimal  "wage_payment",                                                                                    :precision => 12, :scale => 2
    t.datetime "created_at",                                                                                                                     :null => false
    t.datetime "updated_at",                                                                                                                     :null => false
  end

  add_index "employees", ["department_id"], :name => "index_employees_on_department_id"
  add_index "employees", ["entity_id"], :name => "index_employees_on_entity_id"
  add_index "employees", ["means_of_payment_id"], :name => "index_employees_on_means_of_payment_id"
  add_index "employees", ["occupation_id"], :name => "index_employees_on_occupation_id"
  add_index "employees", ["payment_frequency_id"], :name => "index_employees_on_payment_frequency_id"
  add_index "employees", ["payment_method_id"], :name => "index_employees_on_payment_method_id"
  add_index "employees", ["role_id"], :name => "index_employees_on_role_id"

  create_table "entities", :force => true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "entityid"
    t.enum     "typeid",     :limit => [:national, :foreign, :company]
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  create_table "items_purchase_orders", :force => true do |t|
    t.integer  "purchase_order_id"
    t.string   "product"
    t.string   "description"
    t.integer  "quantity"
    t.float    "cost_unit"
    t.float    "cost_total"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.integer  "warehouse_id"
    t.decimal  "discount",          :precision => 17, :scale => 2
  end

  add_index "items_purchase_orders", ["purchase_order_id"], :name => "index_items_purchase_orders_on_purchase_order_id"
  add_index "items_purchase_orders", ["warehouse_id"], :name => "index_items_purchase_orders_on_warehouse_id"

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

  create_table "means_of_payments", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "occupations", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "payment_frequencies", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "payment_methods", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "payment_options", :force => true do |t|
    t.string   "name"
    t.string   "related_account"
    t.boolean  "use_expenses"
    t.boolean  "use_incomes"
    t.boolean  "require_transaction"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "payment_schedules", :force => true do |t|
    t.string   "code"
    t.string   "description"
    t.date     "initial_date"
    t.date     "end_date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.date     "payment_date"
  end

  create_table "photos", :force => true do |t|
    t.integer  "employee_id"
    t.string   "url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "photos", ["employee_id"], :name => "index_photos_on_employee_id"

  create_table "product_aplications", :force => true do |t|
    t.string   "name"
    t.integer  "product_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "product_aplications", ["product_id"], :name => "index_product_aplications_on_product_id"

  create_table "product_applications", :force => true do |t|
    t.string   "name"
    t.integer  "product_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "product_applications", ["product_id"], :name => "index_product_applications_on_product_id"

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

  create_table "purchase_items", :force => true do |t|
    t.integer  "purchase_id"
    t.integer  "product_id"
    t.string   "description"
    t.float    "quantity"
    t.float    "cost_unit"
    t.float    "cost_total"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "warehouse_id"
    t.decimal  "discount",     :precision => 17, :scale => 2
  end

  add_index "purchase_items", ["product_id"], :name => "index_purchase_items_on_product_id"
  add_index "purchase_items", ["purchase_id"], :name => "index_purchase_items_on_purchase_id"
  add_index "purchase_items", ["warehouse_id"], :name => "index_purchase_items_on_warehouse_id"

  create_table "purchase_orders", :force => true do |t|
    t.integer  "vendor_id"
    t.string   "reference_info"
    t.string   "currency"
    t.text     "observation"
    t.float    "subtotal"
    t.float    "taxes"
    t.float    "total"
    t.date     "delivery_date"
    t.string   "shipping_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "purchase_orders", ["vendor_id"], :name => "index_purchase_orders_on_vendor_id"

  create_table "purchases", :force => true do |t|
    t.string   "document_number"
    t.integer  "vendor_id"
    t.date     "purchase_date"
    t.boolean  "completed"
    t.string   "currency"
    t.float    "subtotal"
    t.float    "taxes"
    t.float    "total"
    t.enum     "purchase_type",   :limit => [:local, :imported]
    t.string   "dai_tax"
    t.string   "isc_tax"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "purchases", ["vendor_id"], :name => "index_purchases_on_vendor_id"

  create_table "roles", :force => true do |t|
    t.string   "role"
    t.string   "description"
    t.integer  "department_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["department_id"], :name => "index_roles_on_department_id"

  create_table "shipping_methods", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "sublines", :force => true do |t|
    t.string   "code"
    t.string   "description"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "telephones", :force => true do |t|
    t.integer  "entity_id"
    t.string   "telephone"
    t.enum     "typephone",  :limit => [:personal, :home, :work]
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "telephones", ["entity_id"], :name => "index_telephones_on_entity_id"

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

  create_table "vendors", :force => true do |t|
    t.string   "credit_limit"
    t.integer  "entity_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "vendors", ["entity_id"], :name => "index_vendors_on_entity_id"

  create_table "warehouses", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "description"
    t.string   "manager"
    t.string   "address"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "work_benefits", :force => true do |t|
    t.string   "description"
    t.integer  "employee_id"
    t.string   "frequency"
    t.string   "calculation_method"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "work_benefits", ["employee_id"], :name => "index_work_benefits_on_employee_id"

end
