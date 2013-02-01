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

attr_accessible :code, :description, :income, :inventory, 
								  :lost_adjustment, :name, :purchase_return, 
									:purchase_tax, :sale_cost, :sale_tax, 
									:sales_return, :utility_adjusment

validates :code, :length => { :within => 1..10 },:uniqueness => { :case_sensitive => false }

validates :code, :name, :sale_tax, :purchase_tax, :presence => true	

validates  :inventory, :sale_cost, :utility_adjusment, :lost_adjustment, :income, :sales_return, 
		   :purchase_return, :format => { :with => /[0-9]/, 
		   	:message => :not_a_number }, :allow_blank => true

validates :sale_tax, :purchase_tax, :numericality => true
=begin
validates 	:income, :inventory, :lost_adjustment, :purchase_return, 
						:purchase_tax, :sale_cost, :sale_tax, :sales_return, :utility_adjusment,		
							:numericality => { :only_integer => true, :greater_than => 0 }
=end
	def self.fetch
		Rails.cache.fetch("Line.all"){ find(:all, :select =>['id','name']).to_json } 
	end

	def self.clean_cache
		Rails.cache.delete("Line.all")
	end
end
