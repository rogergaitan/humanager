class PayrollTypeOtherPayment < ActiveRecord::Base
  attr_accessible :payroll_type_id, :other_payment_id
  belongs_to :payroll_type
  belongs_to :other_payment
end
