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

ActiveRecord::Schema.define(:version => 20130225212921) do

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

  create_table "centro_de_costos", :force => true do |t|
    t.string   "iempresa"
    t.string   "icentro_costo"
    t.string   "nombre_cc"
    t.string   "icc_padre"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "company_id"
    t.string   "telephone"
    t.string   "address"
    t.string   "email"
    t.string   "web_site"
    t.boolean  "default"
    t.string   "logo"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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

  create_table "cost_centers", :force => true do |t|
    t.string   "code"
    t.string   "description"
    t.integer  "employee_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

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

  create_table "deduction_employees", :force => true do |t|
    t.integer  "deduction_id"
    t.integer  "employee_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "current_balance"
  end

  add_index "deduction_employees", ["deduction_id"], :name => "index_deduction_employees_on_deduction_id"
  add_index "deduction_employees", ["employee_id"], :name => "index_deduction_employees_on_employee_id"

  create_table "deduction_payments", :force => true do |t|
    t.integer  "deduction_employee_id"
    t.date     "payment_date"
    t.integer  "previous_balance"
    t.integer  "payment"
    t.integer  "current_balance"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "deduction_payments", ["deduction_employee_id"], :name => "index_deduction_payments_on_deduction_employee_id"

  create_table "deduction_payrolls", :force => true do |t|
    t.integer  "deduction_id"
    t.integer  "payroll_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "deduction_payrolls", ["deduction_id"], :name => "index_deduction_payrolls_on_deduction_id"
  add_index "deduction_payrolls", ["payroll_id"], :name => "index_deduction_payrolls_on_payroll_id"

  create_table "deductions", :force => true do |t|
    t.string   "description"
    t.enum     "deduction_type",    :limit => [:Constante, :Unica, :Monto_Agotar]
    t.decimal  "amount_exhaust",                                                   :precision => 10, :scale => 0
    t.enum     "calculation_type",  :limit => [:porcentual, :fija]
    t.decimal  "calculation",                                                      :precision => 18, :scale => 4
    t.integer  "ledger_account_id"
    t.datetime "created_at",                                                                                                        :null => false
    t.datetime "updated_at",                                                                                                        :null => false
    t.boolean  "state",                                                                                           :default => true
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.integer  "employee_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "centro_de_costos_id"
  end

  add_index "departments", ["employee_id"], :name => "index_departments_on_employee_id"

  create_table "discount_profile_items", :force => true do |t|
    t.integer  "discount_profile_id"
    t.enum     "item_type",           :limit => [:product, :subline]
    t.integer  "item_id"
    t.float    "discount"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  create_table "discount_profiles", :force => true do |t|
    t.string   "description"
    t.enum     "category",    :limit => [:a, :b, :c]
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "districts", :force => true do |t|
    t.string   "name"
    t.integer  "canton_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "province_id"
  end

  add_index "districts", ["canton_id"], :name => "index_districts_on_canton_id"
  add_index "districts", ["province_id"], :name => "index_districts_on_province_id"

  create_table "document_numbers", :force => true do |t|
    t.integer  "company_id"
    t.string   "description"
    t.enum     "document_type",        :limit => [:purchase, :purchase_order, :quotation, :invoice]
    t.enum     "number_type",          :limit => [:auto_increment, :manual]
    t.integer  "start_number"
    t.string   "mask"
    t.boolean  "terminal_restriction"
    t.datetime "created_at",                                                                         :null => false
    t.datetime "updated_at",                                                                         :null => false
  end

  add_index "document_numbers", ["company_id"], :name => "index_document_numbers_on_company_id"

  create_table "emails", :force => true do |t|
    t.integer  "entity_id"
    t.string   "email"
    t.enum     "typeemail",  :limit => [:personal, :work]
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "emails", ["entity_id"], :name => "index_emails_on_entity_id"

  create_table "employee_benefits", :force => true do |t|
    t.integer  "work_benefit_id"
    t.integer  "employee_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "employee_benefits", ["employee_id"], :name => "index_employee_benefits_on_employee_id"
  add_index "employee_benefits", ["work_benefit_id"], :name => "index_employee_benefits_on_work_benefit_id"

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
    t.datetime "created_at",                                                                                                                                        :null => false
    t.datetime "updated_at",                                                                                                                                        :null => false
    t.string   "position_id"
    t.integer  "employee_id"
    t.boolean  "is_superior",                                                                                                                    :default => false
  end

  add_index "employees", ["department_id"], :name => "index_employees_on_department_id"
  add_index "employees", ["employee_id"], :name => "index_employees_on_employee_id"
  add_index "employees", ["entity_id"], :name => "index_employees_on_entity_id"
  add_index "employees", ["means_of_payment_id"], :name => "index_employees_on_means_of_payment_id"
  add_index "employees", ["occupation_id"], :name => "index_employees_on_occupation_id"
  add_index "employees", ["payment_frequency_id"], :name => "index_employees_on_payment_frequency_id"
  add_index "employees", ["payment_method_id"], :name => "index_employees_on_payment_method_id"
  add_index "employees", ["position_id"], :name => "index_employees_on_position_id"
  add_index "employees", ["role_id"], :name => "index_employees_on_role_id"

  create_table "empmaestccs", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "entities", :force => true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "entityid"
    t.enum     "typeid",     :limit => [:national, :foreign, :company]
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  create_table "fields_personnel_actions", :force => true do |t|
    t.string   "name"
    t.string   "field_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invoice_items", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "warehouse_id"
    t.string   "code"
    t.string   "description"
    t.float    "ordered_quantity"
    t.float    "available_quantity"
    t.float    "quantity"
    t.float    "cost_unit"
    t.float    "discount"
    t.float    "tax"
    t.float    "cost_total"
    t.integer  "product_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "invoice_items", ["invoice_id"], :name => "index_invoice_items_on_invoice_id"
  add_index "invoice_items", ["product_id"], :name => "index_invoice_items_on_product_id"
  add_index "invoice_items", ["warehouse_id"], :name => "index_invoice_items_on_warehouse_id"

  create_table "invoices", :force => true do |t|
    t.string   "document_number"
    t.date     "document_date"
    t.integer  "customer_id"
    t.string   "currency"
    t.string   "price_list"
    t.string   "payment_term"
    t.date     "due_date"
    t.integer  "quotation_id"
    t.boolean  "closed"
    t.float    "sub_total_free"
    t.float    "sub_total_taxed"
    t.float    "discount_total"
    t.float    "tax_total"
    t.float    "total"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "invoices", ["customer_id"], :name => "index_invoices_on_customer_id"
  add_index "invoices", ["quotation_id"], :name => "index_invoices_on_quotation_id"

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
    t.float    "tax"
  end

  add_index "items_purchase_orders", ["purchase_order_id"], :name => "index_items_purchase_orders_on_purchase_order_id"
  add_index "items_purchase_orders", ["warehouse_id"], :name => "index_items_purchase_orders_on_warehouse_id"

  create_table "kardexes", :force => true do |t|
    t.integer  "company_id"
    t.date     "mov_date"
    t.integer  "mov_id"
    t.enum     "mov_type",     :limit => [:input, :output]
    t.string   "doc_type"
    t.string   "doc_number"
    t.integer  "entity_id"
    t.string   "current_user"
    t.string   "code"
    t.string   "cost_unit"
    t.string   "discount"
    t.string   "tax"
    t.string   "cost_total"
    t.string   "price_list"
    t.float    "quantity"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "kardexes", ["company_id"], :name => "index_kardexes_on_company_id"
  add_index "kardexes", ["entity_id"], :name => "index_kardexes_on_entity_id"

  create_table "ledger_accounts", :force => true do |t|
    t.string   "iaccount"
    t.string   "naccount"
    t.string   "ifather"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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

  create_table "other_salaries", :force => true do |t|
    t.string   "description"
    t.integer  "ledger_account_id"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.decimal  "amount",            :precision => 18, :scale => 2
    t.boolean  "state",                                            :default => true
  end

  create_table "other_salary_employees", :force => true do |t|
    t.integer  "other_salary_id"
    t.integer  "employee_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.decimal  "amount",          :precision => 18, :scale => 2
  end

  add_index "other_salary_employees", ["employee_id"], :name => "index_other_salary_employees_on_employee_id"
  add_index "other_salary_employees", ["other_salary_id"], :name => "index_other_salary_employees_on_other_salary_id"

  create_table "other_salary_payments", :force => true do |t|
    t.integer  "other_salary_employee_id"
    t.date     "payment_date"
    t.integer  "payment"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "other_salary_payments", ["other_salary_employee_id"], :name => "index_other_salary_payments_on_other_salary_employee_id"

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

  create_table "payment_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payroll_employees", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "payroll_log_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "payroll_employees", ["employee_id"], :name => "index_payroll_employees_on_employee_id"
  add_index "payroll_employees", ["payroll_log_id"], :name => "index_payroll_employees_on_payroll_log_id"

  create_table "payroll_histories", :force => true do |t|
    t.integer  "task_id"
    t.string   "time_worked"
    t.integer  "centro_de_costo_id"
    t.enum     "payment_type",       :limit => [:Ordinario, :Extra, :Doble]
    t.integer  "payroll_log_id"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  add_index "payroll_histories", ["centro_de_costo_id"], :name => "index_payroll_histories_on_centro_de_costo_id"
  add_index "payroll_histories", ["payroll_log_id"], :name => "index_payroll_histories_on_payroll_log_id"
  add_index "payroll_histories", ["task_id"], :name => "index_payroll_histories_on_task_id"

  create_table "payroll_logs", :force => true do |t|
    t.integer  "payroll_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.date     "payroll_date"
  end

  add_index "payroll_logs", ["payroll_id"], :name => "index_payroll_logs_on_payroll_id"

  create_table "payroll_types", :force => true do |t|
    t.string   "description"
    t.enum     "payroll_type", :limit => [:Administrativa, :Campo, :Planta]
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "payrolls", :force => true do |t|
    t.integer  "payroll_type_id"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "payment_date"
    t.boolean  "state",           :default => true
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "payrolls", ["payroll_type_id"], :name => "index_payrolls_on_payroll_type_id"

  create_table "personalized_fields", :force => true do |t|
    t.integer  "type_of_personnel_action_id"
    t.integer  "fields_personnel_action_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "personalized_fields", ["fields_personnel_action_id"], :name => "index_personalized_fields_on_fields_personnel_action_id"
  add_index "personalized_fields", ["type_of_personnel_action_id"], :name => "index_personalized_fields_on_type_of_personnel_action_id"

  create_table "photos", :force => true do |t|
    t.integer  "employee_id"
    t.string   "name"
    t.string   "photo"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "photos", ["employee_id"], :name => "index_photos_on_employee_id"

  create_table "positions", :force => true do |t|
    t.string   "position"
    t.string   "description"
    t.string   "codigo_ins"
    t.string   "codigo_ccss"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

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
    t.float    "tax"
    t.string   "code"
  end

  add_index "purchase_items", ["product_id"], :name => "index_purchase_items_on_product_id"
  add_index "purchase_items", ["purchase_id"], :name => "index_purchase_items_on_purchase_id"
  add_index "purchase_items", ["warehouse_id"], :name => "index_purchase_items_on_warehouse_id"

  create_table "purchase_order_payments", :force => true do |t|
    t.integer  "payment_option_id"
    t.integer  "payment_type_id"
    t.integer  "purchase_order_id"
    t.string   "number"
    t.float    "amount"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "purchase_order_payments", ["payment_option_id"], :name => "index_purchase_order_payments_on_payment_option_id"
  add_index "purchase_order_payments", ["payment_type_id"], :name => "index_purchase_order_payments_on_payment_type_id"
  add_index "purchase_order_payments", ["purchase_order_id"], :name => "index_purchase_order_payments_on_purchase_order_id"

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
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.date     "document_date"
    t.string   "document_number"
  end

  add_index "purchase_orders", ["vendor_id"], :name => "index_purchase_orders_on_vendor_id"

  create_table "purchase_payment_options", :force => true do |t|
    t.integer  "payment_option_id"
    t.integer  "payment_type_id"
    t.integer  "purchase_id"
    t.string   "number"
    t.float    "amount"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "purchase_payment_options", ["payment_option_id"], :name => "index_purchase_payment_options_on_payment_option_id"
  add_index "purchase_payment_options", ["payment_type_id"], :name => "index_purchase_payment_options_on_payment_type_id"
  add_index "purchase_payment_options", ["purchase_id"], :name => "index_purchase_payment_options_on_purchase_id"

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

  create_table "quotation_items", :force => true do |t|
    t.integer  "quotation_id"
    t.integer  "product_id"
    t.string   "code"
    t.string   "description"
    t.float    "quantity"
    t.float    "unit_price"
    t.float    "discount"
    t.float    "tax"
    t.float    "total"
    t.integer  "warehouse_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "quotation_items", ["product_id"], :name => "index_quotation_items_on_product_id"
  add_index "quotation_items", ["quotation_id"], :name => "index_quotation_items_on_quotation_id"
  add_index "quotation_items", ["warehouse_id"], :name => "index_quotation_items_on_warehouse_id"

  create_table "quotations", :force => true do |t|
    t.string   "document_number"
    t.integer  "customer_id"
    t.string   "currency"
    t.date     "document_date"
    t.date     "valid_to"
    t.string   "payment_term"
    t.float    "sub_total_free"
    t.float    "sub_total_taxed"
    t.float    "tax_total"
    t.float    "discount_total"
    t.float    "total"
    t.text     "notes"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "quotations", ["customer_id"], :name => "index_quotations_on_customer_id"

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

  create_table "tasks", :force => true do |t|
    t.string   "iactivity"
    t.string   "itask"
    t.string   "ntask"
    t.string   "iaccount"
    t.decimal  "mlaborcost", :precision => 18, :scale => 4
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "taxes", :force => true do |t|
    t.string   "name"
    t.float    "percentage"
    t.string   "cc_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "telephones", :force => true do |t|
    t.integer  "entity_id"
    t.string   "telephone"
    t.enum     "typephone",  :limit => [:personal, :home, :work]
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "telephones", ["entity_id"], :name => "index_telephones_on_entity_id"

  create_table "type_of_personnel_actions", :force => true do |t|
    t.string   "description"
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
    t.decimal  "percentage",     :precision => 12, :scale => 2
    t.integer  "debit_account"
    t.integer  "credit_account"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "work_benefits", ["credit_account"], :name => "index_work_benefits_on_credit_account"
  add_index "work_benefits", ["debit_account"], :name => "index_work_benefits_on_debit_account"

end
