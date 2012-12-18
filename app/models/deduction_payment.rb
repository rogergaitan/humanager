class DeductionPayment < ActiveRecord::Base
  belongs_to :deduction_employee
  attr_accessible :current_balance, :payment, :payment_date, :previous_balance, :deduction_employee_id
end
