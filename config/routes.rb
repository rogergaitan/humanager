# -*- encoding : utf-8 -*-
Reasapp::Application.routes.draw do

  resources :reports do
    collection do
      get :search_payrolls
      get :create_pdf_proof_pay_employees
      get :general_payroll
      get :general_payroll_xls
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
    end
  end
  
  resources :payroll_logs

  resources :payrolls do
    collection do
      get :get_activas
      get :get_inactivas
      get :get_payroll_types
      get :load_payrolls
    end
    collection do
      post :reabrir
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
    end
  end

  resources :work_benefits

  resources :payroll_types

  resources :centro_de_costos do
    collection do
      get 'sync_cc'
    end
    collection do
      get 'load_cc'
    end
  end

  resources :centro_de_costos

  resources :positions

  resources :ledger_accounts do
    collection do
      get 'accountfb'
      get 'fetch'
    end
    collection do
      get 'accountfb'
    end
  end

  resources :tasks do
    collection do
      get 'tasksfb'
      get 'load_cc'
    end
  end

  resources :districts

  resources :cantons

  resources :provinces

  resources :departments

  resources :means_of_payments

  resources :payment_frequencies

  resources :employees do
    collection do
      get 'sync'
      get :search
      get :search_all
    end
    collection do
      get 'load_employees'
      get 'load_em'
    end
  end

  resources :employees

  resources :occupations

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
