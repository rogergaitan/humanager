# == Schema Information
#
# Table name: warehouses
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  name        :string(255)
#  description :string(255)
#  manager     :string(255)
#  address     :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

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
