# -*- encoding : utf-8 -*-
Reasapp::Application.routes.draw do

  get "supports/index"

  post "session_validation/update_time"

  resources :other_payments do
    collection do
      get :search
      get :validate_name_uniqueness
    end
  end

  resources :permissions_users
  
  devise_for :users

  match "users/permissions/:id", :controller => "users", :action => 'permissions', :as => :permissions_user, via: [:get]
  match "users", :controller => "users", :action => 'index', via: [:get]
  match "users/:id/edit", :controller => "users", :action => 'edit', :as => :edit_user, via: [:get]
  match "users/:id", :controller => "users", :action => 'update', via: [:put]
  match "users", :controller => "users", :action => 'delete', :as => :user, via: [:delete]
  match "users/usersfb", :controller => "users", :action => 'usersfb', :as => :usersfb_users, via: [:get]
  match "users/search_user", :controller => "users", :action => 'search_user', :as => :search_user_users, via: [:get]
  match "users/get_permissions_user", :controller => "users", :action => 'get_permissions_user', :as => :get_permissions_user_users, via: [:get]
  match "users/save_permissions", :controller => "users", :action => 'save_permissions', :as => :save_permissions_users, via: [:post]
  match "users/change_company", :controller => "users", :action => 'change_company', :as => :change_company_users, via: [:post]

  resources :payment_types do
    collection do
      post :change_status
    end
  end

  resources :reports do
    collection do
      get :search_payrolls
      get :create_pdf_proof_pay_employees
      get :general_payroll
      get :general_payroll_xls
      get :payment_type_report
      get :report_between_dates
      get :accrued_wages_between_dates_report
    end
  end
  get "reports/index"
  match 'reports/index', :to => 'reports#index'

  resources :detail_personnel_actions

  resources :payroll_logs do
    collection do
      get :fetch_employees
      get :search_task
      get :search_cost
      get :search_employee
      get :delete_employee_to_payment
      get :get_history_json
      get :get_employees
      post :set_custom_update
    end
  end
  
  resources :payroll_logs

  resources :payrolls do
    collection do
      get :get_activas
      get :get_inactivas
      get :get_payroll_types
      get :load_payrolls
      get :get_main_calendar
    end
    collection do
      post :reopen
      post :close_payroll
      post :send_to_firebird
    end
  end

  resources :deductions do
    collection do
      get :fetch_employees
      get :get_activas
      get :search_employee
      get 'fetch_payroll_type'
      get :search
      get :validate_description_uniqueness
    end
  end

  resources :type_of_personnel_actions

  resources :other_salaries do
    collection do
      get :fetch_employees
    end
  end
  
  resources :work_benefits do
    collection do
      get 'fetch_debit_accounts'
      get 'fetch_credit_accounts'
      get 'fetch_employees'
      get 'fetch_payroll_type'
      get 'fetch_cost_center'
      get 'search_cost_center'
      get 'search'
      get :validate_name_uniqueness
    end
  end

  resources :work_benefits

  resources :payroll_types do
    collection do
      get :validate_description_uniqueness
    end
  end

  resources :costs_centers do
    collection do
      get :sync_cc
      get :fetch_cc
      get :load_cc
    end
  end

  resources :positions do
    get 'search', on: :collection
  end

  resources :ledger_accounts do
    collection do
      get 'accountfb'
      get 'fetch'
      get 'get_bank_account'
      get 'credit_accounts'
    end
    collection do
      get 'accountfb'
    end
  end

  resources :tasks do
    collection do
      get 'tasksfb'
      get 'load_cc'
      get :fetch_tasks
      get :search
      put :update_costs
    end
  end

  resources :districts

  resources :cantons

  resources :provinces

  resources :departments do
    get 'search', on: :collection 
  end

  resources :means_of_payments

  resources :payment_frequencies

  resources :employees do
    collection do
      get 'sync'
      get :search
      get :search_all
      get :validate_social_insurance_uniqueness
      get :validate_account_bncr_uniqueness
    end
    collection do
      get 'load_employees'
      get 'load_em'
      get 'search_employee_by_id'
      get 'search_employee_by_code'
      get 'search_employee_by_name'
    end
  end

  resources :employees

  resources :occupations do
    get 'search', on: :collection  
  end

  resources :customers

  resources :entities
  resources :product_pricings
  resources :products
  resources :warehouses
  devise_for :users

  get "pages/home"
  get "pages/about"
  get "pages/help"
  get "pages/contact"

  match '/contact', :to => 'pages#contact'
  match '/help', :to => 'pages#help'
  match '/about', :to => 'pages#about'
  match '/404', :to => 'errors#not_found'
  match '/configuracion', :to  => 'pages#configuracion', :as  => 'dcerp_config'
  match '/procesos', :to  => 'pages#procesos', :as  => 'dcerp_process'

  root :to => 'pages#index'

  resources :lines do
    collection do
      get 'fetch'
    end
  end

  resources :categories do
    collection do
      get 'fetch'
    end
  end

  resources :sublines do
    collection do
      get 'fetch'
    end
  end

  resources :vendors
  resources :sublines
  resources :categories
  resources :lines

  resources :companies, only: [:index] do
    collection do
      get :companies_fb
    end
  end
  
  resources :currencies, only: [:index, :edit, :update]
  
  resources :creditors, only: [:index]
  
  resources :ir_tables do
    collection do
      get :validate_name_uniqueness  
    end
  end
  
  resources :supports, only: [:index]
  
  resources :payment_units, except: [:show]

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'fetch'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
