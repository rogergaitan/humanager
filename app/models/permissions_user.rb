# == Schema Information
#
# Table name: permissions_users
#
#  id          :integer          not null, primary key
#  user_id integer not null, foreing key
#  permissions_subcategory_id integer not null, foreing key
#  create 	   :tinyint(1) 			null
#  view 	   :tinyint(1) 			null
#  modify 	   :tinyint(1) 			null
#  delete 	   :tinyint(1) 			null
#  close 	   :tinyint(1) 			null
#  accounts    :tinyint(1) 			null
#  pdf 		   :tinyint(1) 			null
#  exel 	   :tinyint(1) 			null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null

class PermissionsUser < ActiveRecord::Base
  	
	belongs_to :user
  	belongs_to :permissions_subcategory

	attr_accessible :permissions_subcategory_id, :user_id, :p_create, :p_view,
		:p_modify, :p_delete, :p_close, :p_accounts, :p_pdf, :p_exel

 	# validates :permissions_subcategory_id, :user_id,
 	# 				:presence => true
 	
 	# validates :p_create, :p_view, :p_modify, :p_delete, :p_close,
 	# 			:p_accounts, :p_pdf, :p_exel,
 	# 				:presence => true, :inclusion => {:in => [true, false]}

	
end