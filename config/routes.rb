# -*- encoding : utf-8 -*-
Reasapp::Application.routes.draw do

  get "pages/home"
  get "pages/about"
  get "pages/help"
  get "pages/contact"

  match '/contact', :to => 'pages#contact'
  match '/help', :to => 'pages#help'
  match '/about', :to => 'pages#about'
  match '/404', :to => 'errors#not_found'
  
  root :to => 'pages#home'

  resources :employees do
    collection do
      get 'sync'
    end
    collection do
      get 'load_employees'
    end
  end

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

  resources :purchase_orders do
    collection do
      get 'searchProduct'
      get 'cart_items'
      get 'searchVendor'
      post 'createvendor'
      post 'tovendor'
    end
  end

  resources :products do
    collection do
      get 'search'
      post 'set_cart'
      get 'get_cart'
    end
  end

  resources :warehouses do
    collection do
      get 'fetch'
    end
  end

  devise_for :users

  resources :districts
  resources :cantons
  resources :provinces
  resources :roles
  resources :departments
  resources :means_of_payments
  resources :payment_frequencies
  resources :payment_methods
  resources :payment_schedules
  resources :employees
  resources :deductions
  resources :work_benefits
  resources :occupations
  resources :customers
  resources :entities
  resources :product_pricings
  resources :warehouses
  resources :purchase_orders
  resources :products
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
