class Line < ActiveRecord::Base
attr_accessible 	:code, :description, :income, :inventory, 
  					:lost_adjustment, :name, :purchase_return, 
  					:purchase_tax, :sale_cost, :sale_tax, 
  					:sales_return, :utility_adjusment

validates 	:code, 
				:presence => true, 
				:length => { :within => 4..10 },
				:uniqueness => { :case_sensitive => false }

validates 	:description, :income, :inventory, 
			:lost_adjustment, :name, :purchase_return, 
			:purchase_tax, :sale_cost, :sale_tax, 
			:sales_return, :utility_adjusment,

				:presence => true	

validates 	:income, :inventory, :lost_adjustment, :purchase_return, 
			:purchase_tax, :sale_cost, :sale_tax, :sales_return, :utility_adjusment,
			
				:numericality => { :only_integer => true, :greater_than => 0 }

end
