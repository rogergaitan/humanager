class OtherPaymentPayment < ActiveRecord::Base
  belongs_to :other_payment_employee
  belongs_to :payroll
  belongs_to :currency
  attr_accessible :payment, :payment_date, :other_payment_employee_id, :payroll_id
  
  def other_payment_value
    if other_payment_employee.other_payment.individual?
      other_payment_employee.calculation
    else
      other_payment_employee.other_payment.amount
    end
  end
  
end
