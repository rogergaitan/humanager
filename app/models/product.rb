# == Schema Information
#
# Table name: products
#
#  id           :integer          not null, primary key
#  code         :string(255)
#  line_id      :integer
#  subline_id   :integer
#  category_id  :integer
#  part_number  :string(255)
#  name         :string(255)
#  make         :string(255)
#  model        :string(255)
#  year         :string(255)
#  version      :string(255)
#  max_discount :integer
#  address      :string(255)
#  max_cant     :integer
#  min_cant     :integer
#  cost         :float
#  bar_code     :string(255)
#  market_price :integer
#  status       :enum([:active, :
#  stock        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

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
