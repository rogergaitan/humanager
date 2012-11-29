class DeductionPayrolls < ActiveRecord::Base
	attr_accessible :deduction_id, :payroll_id
  	belongs_to :deduction
  	belongs_to :payroll
end
