class DeductionPayment < ActiveRecord::Base
  belongs_to :deduction_employee
  has_many :payroll
  attr_accessible :current_balance, :payment, :payment_date, :previous_balance, :deduction_employee_id, :payroll_id
end