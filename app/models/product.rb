class Product < ActiveRecord::Base
	
	belongs_to :subline
	belongs_to :line
	belongs_to :category
	
	attr_accessible	:address, :bar_code, :category_id, 
  					:code, :cost, :line_id, :make, :market_price, :max_cant, 
  					:max_discount, :min_cant, :model, :name, :part_number, 
  					:status, :stock, :subline_id, :version, :year
  	validates :code, 
					:presence => true, 
					:length => { :within => 4..10 },
						:uniqueness => { :case_sensitive => false }

	validates 	:address, :bar_code, :category_id, 
				:code, :cost, :line_id, :make, :market_price, :max_cant, 
				:max_discount, :min_cant, :model, :name, :part_number, 
				:status, :stock, :subline_id, :version, :year, 
					:presence => true		
					
	validates :name, 
					:presence => true
end
