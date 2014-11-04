class OtherPaymentPayroll < ActiveRecord::Base
  belongs_to :other_payment
  belongs_to :payroll
  attr_accessible :other_payment_id, :payroll_id
end
