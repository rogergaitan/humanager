class DeductionPayroll < ActiveRecord::Base
  belongs_to :deduction
  belongs_to :payroll
  attr_accessible :deduction_id, :payroll_id
end
