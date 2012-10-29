# == Schema Information
#
# Table name: lines
#
#  id                :integer          not null, primary key
#  code              :string(255)
#  name              :string(255)
#  description       :string(255)
#  inventory         :integer
#  sale_cost         :integer
#  utility_adjusment :integer
#  lost_adjustment   :integer
#  income            :integer
#  sales_return      :integer
#  purchase_return   :integer
#  sale_tax          :integer
#  purchase_tax      :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Line < ActiveRecord::Base

has_many :products

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
