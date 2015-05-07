class PayrollEmployee < ActiveRecord::Base
  belongs_to :employee
  belongs_to :payroll_history
  after_destroy :check_children

  attr_accessible :employee_id, :payroll_history_id

  def check_children
  	PayrollHistory.delete(payroll_history_id) if PayrollEmployee.find_by_payroll_history_id(payroll_history_id).nil?
  end
end
