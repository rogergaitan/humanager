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

ActiveRecord::Schema.define(:version => 20141125161545) do

  create_table "addresses", :force => true do |t|
    t.integer  "entity_id"
    t.integer  "province_id"
    t.integer  "canton_id"
    t.integer  "district_id"
    t.string   "address"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "addresses", ["canton_id"], :name => "index_addresses_on_canton_id"
  add_index "addresses", ["district_id"], :name => "index_addresses_on_district_id"
  add_index "addresses", ["entity_id"], :name => "index_addresses_on_entity_id"
  add_index "addresses", ["province_id"], :name => "index_addresses_on_province_id"

  create_table "bank_accounts", :force => true do |t|
    t.integer  "entity_id"
    t.string   "bank"
    t.string   "bank_account"
    t.string   "sinpe"
    t.string   "account_title"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "bank_accounts", ["entity_id"], :name => "index_bank_accounts_on_entity_id"

  create_table "cantons", :force => true do |t|
    t.integer  "province_id"
    t.string   "name"
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

  create_table "companies", :force => true do |t|
    t.integer  "code"
    t.string   "name"
    t.text     "label_reports_1"
    t.text     "label_reports_2"
    t.text     "label_reports_3"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "contacts", :force => true do |t|
    t.integer  "entity_id"
    t.string   "name"
    t.string   "occupation"
    t.string   "phone"
    t.string   "email"
    t.string   "skype"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "contacts", ["entity_id"], :name => "index_contacts_on_entity_id"

  create_table "costs_centers", :force => true do |t|
    t.string   "icompany"
    t.string   "icost_center"
    t.string   "name_cc"
    t.string   "icc_father"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "customer_profiles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "customers", :force => true do |t|
    t.integer  "customer_profile_id"
    t.integer  "entity_id"
    t.string   "asigned_seller"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "customers", ["customer_profile_id"], :name => "index_customers_on_customer_profile_id"
  add_index "customers", ["entity_id"], :name => "index_customers_on_entity_id"

  create_table "deduction_employees", :force => true do |t|
    t.integer  "deduction_id"
    t.integer  "employee_id"
    t.boolean  "completed",                                   :default => false
    t.boolean  "boolean",                                     :default => false
    t.decimal  "calculation",  :precision => 10, :scale => 2
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  add_index "deduction_employees", ["deduction_id"], :name => "index_deduction_employees_on_deduction_id"
  add_index "deduction_employees", ["employee_id"], :name => "index_deduction_employees_on_employee_id"

  create_table "deduction_payments", :force => true do |t|
    t.integer  "deduction_employee_id"
    t.integer  "payroll_id"
    t.date     "payment_date"
    t.decimal  "previous_balance",      :precision => 10, :scale => 2
    t.decimal  "payment",               :precision => 10, :scale => 2
    t.decimal  "current_balance",       :precision => 10, :scale => 2
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "deduction_payments", ["deduction_employee_id"], :name => "index_deduction_payments_on_deduction_employee_id"
  add_index "deduction_payments", ["payroll_id"], :name => "index_deduction_payments_on_payroll_id"

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
    t.enum     "deduction_type",    :limit => [:constant, :unique, :amount_to_exhaust]
    t.decimal  "amount_exhaust",                                                        :precision => 10, :scale => 2
    t.decimal  "decimal",                                                               :precision => 10, :scale => 2
    t.enum     "calculation_type",  :limit => [:percentage, :fixed]
    t.integer  "ledger_account_id"
    t.enum     "state",             :limit => [:completed, :active],                                                   :default => :active
    t.string   "beneficiary_id"
    t.boolean  "is_beneficiary",                                                                                       :default => true
    t.boolean  "individual",                                                                                           :default => false
    t.datetime "created_at",                                                                                                                :null => false
    t.datetime "updated_at",                                                                                                                :null => false
  end

  create_table "departments", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "costs_center_id"
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "departments", ["costs_center_id"], :name => "index_departments_on_costs_center_id"
  add_index "departments", ["employee_id"], :name => "index_departments_on_employee_id"

  create_table "detail_personnel_actions", :force => true do |t|
    t.integer  "type_of_personnel_action_id"
    t.integer  "fields_personnel_action_id"
    t.string   "value"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "detail_personnel_actions", ["fields_personnel_action_id"], :name => "index_detail_personnel_actions_on_fields_personnel_action_id"
  add_index "detail_personnel_actions", ["type_of_personnel_action_id"], :name => "index_detail_personnel_actions_on_type_of_personnel_action_id"

  create_table "districts", :force => true do |t|
    t.integer  "canton_id"
    t.integer  "province_id"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
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

  create_table "employee_benefits", :force => true do |t|
    t.integer  "work_benefit_id"
    t.integer  "employee_id"
    t.boolean  "completed",       :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
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
    t.integer  "department_id"
    t.integer  "occupation_id"
    t.integer  "role_id"
    t.integer  "position_id"
    t.boolean  "seller"
    t.integer  "payment_method_id"
    t.integer  "payment_frequency_id"
    t.integer  "means_of_payment_id"
    t.integer  "employee_id"
    t.integer  "payment_unit_id"
    t.integer  "payroll_type_id"
    t.boolean  "is_superior",                                                                                                                    :default => false
    t.boolean  "price_defined_work"
    t.integer  "number_employee"
    t.string   "account_bncr",         :limit => 12
    t.decimal  "wage_payment",                                                                                    :precision => 10, :scale => 2
    t.datetime "created_at",                                                                                                                                        :null => false
    t.datetime "updated_at",                                                                                                                                        :null => false
  end

  add_index "employees", ["department_id"], :name => "index_employees_on_department_id"
  add_index "employees", ["employee_id"], :name => "index_employees_on_employee_id"
  add_index "employees", ["entity_id"], :name => "index_employees_on_entity_id"
  add_index "employees", ["means_of_payment_id"], :name => "index_employees_on_means_of_payment_id"
  add_index "employees", ["number_employee"], :name => "index_employees_on_number_employee", :unique => true
  add_index "employees", ["occupation_id"], :name => "index_employees_on_occupation_id"
  add_index "employees", ["payment_frequency_id"], :name => "index_employees_on_payment_frequency_id"
  add_index "employees", ["payment_method_id"], :name => "index_employees_on_payment_method_id"
  add_index "employees", ["payment_unit_id"], :name => "index_employees_on_payment_unit_id"
  add_index "employees", ["payroll_type_id"], :name => "index_employees_on_payroll_type_id"
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
    t.enum     "typeid",     :limit => [:national_id, :residence_id, :business_id, :passport, :other]
    t.datetime "created_at",                                                                           :null => false
    t.datetime "updated_at",                                                                           :null => false
  end

  create_table "fields_personnel_actions", :force => true do |t|
    t.string   "name"
    t.string   "field_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
    t.string   "ins_code"
    t.string   "ccss_code"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "other_payment_employees", :force => true do |t|
    t.integer  "other_payment_id"
    t.integer  "employee_id"
    t.boolean  "completed",                                       :default => false
    t.decimal  "calculation",      :precision => 10, :scale => 2
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
  end

  add_index "other_payment_employees", ["employee_id"], :name => "index_other_payment_employees_on_employee_id"
  add_index "other_payment_employees", ["other_payment_id"], :name => "index_other_payment_employees_on_other_payment_id"

  create_table "other_payment_payments", :force => true do |t|
    t.integer  "other_payment_employee_id"
    t.integer  "payroll_id"
    t.date     "payment_date"
    t.decimal  "payment",                   :precision => 10, :scale => 2
    t.boolean  "is_salary",                                                :default => false
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
  end

  add_index "other_payment_payments", ["other_payment_employee_id"], :name => "index_other_payment_payments_on_other_payment_employee_id"
  add_index "other_payment_payments", ["payroll_id"], :name => "index_other_payment_payments_on_payroll_id"

  create_table "other_payment_payrolls", :force => true do |t|
    t.integer  "other_payment_id"
    t.integer  "payroll_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "other_payment_payrolls", ["other_payment_id"], :name => "index_other_payment_payrolls_on_other_payment_id"
  add_index "other_payment_payrolls", ["payroll_id"], :name => "index_other_payment_payrolls_on_payroll_id"

  create_table "other_payments", :force => true do |t|
    t.integer  "costs_center_id"
    t.integer  "ledger_account_id"
    t.string   "description"
    t.enum     "deduction_type",     :limit => [:constant, :unique, :amount_to_exhaust]
    t.enum     "calculation_type",   :limit => [:percentage, :fixed]
    t.decimal  "amount",                                                                 :precision => 10, :scale => 2
    t.enum     "state",              :limit => [:completed, :active],                                                   :default => :active
    t.boolean  "constitutes_salary"
    t.boolean  "individual"
    t.datetime "created_at",                                                                                                                 :null => false
    t.datetime "updated_at",                                                                                                                 :null => false
  end

  add_index "other_payments", ["costs_center_id"], :name => "index_other_payments_on_costs_center_id"
  add_index "other_payments", ["ledger_account_id"], :name => "index_other_payments_on_ledger_account_id"

  create_table "payment_frequencies", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "payment_units", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "payroll_employees", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "payroll_history_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "payroll_employees", ["employee_id"], :name => "index_payroll_employees_on_employee_id"
  add_index "payroll_employees", ["payroll_history_id"], :name => "index_payroll_employees_on_payroll_history_id"

  create_table "payroll_histories", :force => true do |t|
    t.integer  "task_id"
    t.integer  "costs_center_id"
    t.integer  "payroll_log_id"
    t.string   "time_worked"
    t.enum     "payment_type",    :limit => [:ordinary, :extra, :double]
    t.decimal  "total",                                                   :precision => 10, :scale => 2
    t.decimal  "task_total",                                              :precision => 10, :scale => 2
    t.string   "task_unidad"
    t.date     "payroll_date"
    t.datetime "created_at",                                                                             :null => false
    t.datetime "updated_at",                                                                             :null => false
  end

  add_index "payroll_histories", ["costs_center_id"], :name => "index_payroll_histories_on_costs_center_id"
  add_index "payroll_histories", ["payroll_log_id"], :name => "index_payroll_histories_on_payroll_log_id"
  add_index "payroll_histories", ["task_id"], :name => "index_payroll_histories_on_task_id"

  create_table "payroll_logs", :force => true do |t|
    t.integer  "payroll_id"
    t.date     "payroll_date"
    t.decimal  "payroll_total", :precision => 10, :scale => 2
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "payroll_logs", ["payroll_id"], :name => "index_payroll_logs_on_payroll_id"

  create_table "payroll_type_benefits", :force => true do |t|
    t.integer  "payroll_type_id"
    t.integer  "work_benefit_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "payroll_type_benefits", ["payroll_type_id"], :name => "index_payroll_type_benefits_on_payroll_type_id"
  add_index "payroll_type_benefits", ["work_benefit_id"], :name => "index_payroll_type_benefits_on_work_benefit_id"

  create_table "payroll_type_deductions", :force => true do |t|
    t.integer  "payroll_type_id"
    t.integer  "deduction_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "payroll_type_deductions", ["deduction_id"], :name => "index_payroll_type_deductions_on_deduction_id"
  add_index "payroll_type_deductions", ["payroll_type_id"], :name => "index_payroll_type_deductions_on_payroll_type_id"

  create_table "payroll_type_other_payments", :force => true do |t|
    t.integer  "payroll_type_id"
    t.integer  "other_payment_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "payroll_type_other_payments", ["other_payment_id"], :name => "index_payroll_type_other_payments_on_other_payment_id"
  add_index "payroll_type_other_payments", ["payroll_type_id"], :name => "index_payroll_type_other_payments_on_payroll_type_id"

  create_table "payroll_types", :force => true do |t|
    t.integer  "ledger_account_id"
    t.string   "description"
    t.enum     "payroll_type",                    :limit => [:administrative, :fieldwork, :plant]
    t.boolean  "state",                                                                            :default => true
    t.integer  "cod_doc_payroll_support"
    t.string   "mask_doc_payroll_support",        :limit => 5
    t.integer  "cod_doc_accounting_support_mov"
    t.string   "mask_doc_accounting_support_mov", :limit => 5
    t.datetime "created_at",                                                                                         :null => false
    t.datetime "updated_at",                                                                                         :null => false
  end

  add_index "payroll_types", ["ledger_account_id"], :name => "index_payroll_types_on_ledger_account_id"

  create_table "payrolls", :force => true do |t|
    t.integer  "company_id"
    t.integer  "payroll_type_id"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "payment_date"
    t.boolean  "state",           :default => true
    t.string   "num_oper"
    t.string   "num_oper_2"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "payrolls", ["company_id"], :name => "index_payrolls_on_company_id"
  add_index "payrolls", ["payroll_type_id"], :name => "index_payrolls_on_payroll_type_id"

  create_table "permissions_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "permissions_subcategories", :force => true do |t|
    t.string   "name"
    t.integer  "permissions_category_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "permissions_subcategories", ["permissions_category_id"], :name => "index_permissions_subcategories_on_permissions_category_id"

  create_table "permissions_users", :force => true do |t|
    t.integer  "permissions_subcategory_id"
    t.integer  "user_id"
    t.boolean  "p_create",                   :default => false
    t.boolean  "p_view",                     :default => false
    t.boolean  "p_modify",                   :default => false
    t.boolean  "p_delete",                   :default => false
    t.boolean  "p_close",                    :default => false
    t.boolean  "p_accounts",                 :default => false
    t.boolean  "p_pdf",                      :default => false
    t.boolean  "p_exel",                     :default => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "permissions_users", ["permissions_subcategory_id"], :name => "index_permissions_users_on_permissions_subcategory_id"
  add_index "permissions_users", ["user_id"], :name => "index_permissions_users_on_user_id"

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
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "product_pricings", :force => true do |t|
    t.integer  "product_id"
    t.float    "utility"
    t.enum     "type",       :limit => [:other, :credit, :cash]
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

  create_table "tasks", :force => true do |t|
    t.string   "iactivity"
    t.string   "itask"
    t.string   "ntask"
    t.string   "iaccount"
    t.decimal  "mlaborcost", :precision => 10, :scale => 2
    t.string   "nunidad"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
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
    t.string   "username"
    t.string   "name"
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
    t.integer  "entity_id"
    t.string   "credit_limit"
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
    t.integer  "costs_center_id"
    t.string   "description"
    t.decimal  "percentage",                                       :precision => 10, :scale => 2
    t.integer  "debit_account"
    t.integer  "credit_account"
    t.string   "beneficiary_id"
    t.boolean  "is_beneficiary",                                                                  :default => true
    t.enum     "state",           :limit => [:completed, :active],                                :default => :active
    t.datetime "created_at",                                                                                           :null => false
    t.datetime "updated_at",                                                                                           :null => false
  end

  add_index "work_benefits", ["costs_center_id"], :name => "index_work_benefits_on_costs_center_id"
  add_index "work_benefits", ["credit_account"], :name => "index_work_benefits_on_credit_account"
  add_index "work_benefits", ["debit_account"], :name => "index_work_benefits_on_debit_account"

  create_table "work_benefits_payments", :force => true do |t|
    t.integer  "employee_benefits_id"
    t.integer  "payroll_id"
    t.date     "payment_date"
    t.decimal  "percentage",           :precision => 10, :scale => 2
    t.decimal  "payment",              :precision => 10, :scale => 2
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  add_index "work_benefits_payments", ["employee_benefits_id"], :name => "index_work_benefits_payments_on_employee_benefits_id"
  add_index "work_benefits_payments", ["payroll_id"], :name => "index_work_benefits_payments_on_payroll_id"

end
