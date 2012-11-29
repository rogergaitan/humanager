class DeductionEmployees < ActiveRecord::Base
	attr_accessible :deduction_id, :employee_id
  	belongs_to :deduction
  	belongs_to :employee
end
