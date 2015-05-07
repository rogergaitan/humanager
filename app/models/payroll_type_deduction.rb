class PayrollTypeDeduction < ActiveRecord::Base
  attr_accessible :payroll_type_id, :deduction_id
  belongs_to :payroll_type
  belongs_to :deduction
end
