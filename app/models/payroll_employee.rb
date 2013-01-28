class PayrollEmployee < ActiveRecord::Base
  belongs_to :employee
  belongs_to :payroll_log
  attr_accessible :employee_id, :payroll_log_id
end
