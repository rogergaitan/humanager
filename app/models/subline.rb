class Subline < ActiveRecord::Base

	has_many :products

  	attr_accessible :code, :description, :name

	validates :code, 
					:presence => true, 
					:length => { :within => 4..10 },
					:uniqueness => { :case_sensitive => false }

	validates :description, 
					:presence => true		
					
	validates :name, 
					:presence => true
end
