# == Schema Information
#
# Table name: sublines
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  description :string(255)
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

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
