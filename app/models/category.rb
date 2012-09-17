# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Category < ActiveRecord::Base
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
