class PayrollEmployee < ActiveRecord::Base
  belongs_to :employee
  belongs_to :payroll_history

  attr_accessible :employee_id, :payroll_history_id
end
