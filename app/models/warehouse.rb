class Warehouse < ActiveRecord::Base
  attr_accessible :address, :code, :description, :manager, :name

    validates :code, 
					:presence => true, 
					:length => { :within => 4..10 },
					:uniqueness => { :case_sensitive => false }

	validates :description, 
					:presence => true		
					
	validates :name, 
					:presence => true
end
