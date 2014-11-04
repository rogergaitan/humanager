class OtherPaymentPayment < ActiveRecord::Base
  belongs_to :other_payment_employee
  attr_accessible :payment, :payment_date, :other_payment_employee_id
end
