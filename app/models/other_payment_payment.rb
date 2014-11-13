class OtherPaymentPayment < ActiveRecord::Base
  belongs_to :other_payment_employee
  belongs_to :payroll
  attr_accessible :payment, :payment_date, :other_payment_employee_id, :payroll_id
end
