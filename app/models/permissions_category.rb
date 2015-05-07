# == Schema Information
#
# Table name: permissions_categories
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PermissionsCategory < ActiveRecord::Base

	has_many :permissions_subcategories, :dependent => :destroy

	attr_accessible :name
  	
	validates :name, 
				:presence => true,
				:length => { :minimum => 4 }
end