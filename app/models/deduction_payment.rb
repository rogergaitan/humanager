class DeductionPayment < ActiveRecord::Base
  belongs_to :deduction_employee
  belongs_to :payroll
  belongs_to :currency
  
  attr_accessible :current_balance, :payment, :payment_date, :previous_balance, 
    :deduction_employee_id, :payroll_id, :currency_id
end
