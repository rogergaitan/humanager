class CostCenter < ActiveRecord::Base

	belongs_to :employee

  attr_accessible :code, :description, :employee_id
  
  validates :code, :description, :presence => true
end
