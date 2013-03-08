# == Schema Information
#
# Table name: cost_centers
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  description :string(255)
#  employee_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CostCenter < ActiveRecord::Base
	
  attr_accessible :code, :description, :employee_id

  validates :code, :description, :presence => true
end
