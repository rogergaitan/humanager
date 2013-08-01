# == Schema Information
#
# Table name: permissions_subcategories
#
#  id          :integer          not null, primary key
#  permission_category_id integer not null, foreing key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PermissionsSubcategory < ActiveRecord::Base
  	
  	belongs_to :permissions_category

	attr_accessible :permissions_category_id, :name

  	validates :name, 
				:presence => true,
				:length => { :minimum => 4 }

	validates :permissions_category_id,
				:presence => true
end