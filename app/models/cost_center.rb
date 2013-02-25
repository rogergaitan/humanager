class CostCenter < ActiveRecord::Base
	
  attr_accessible :code, :description, :employee_id

  validates :code, :description, :presence => true
end
