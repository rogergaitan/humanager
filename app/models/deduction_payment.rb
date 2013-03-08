# == Schema Information
#
# Table name: deduction_payments
#
#  id                    :integer          not null, primary key
#  deduction_employee_id :integer
#  payment_date          :date
#  previous_balance      :integer
#  payment               :integer
#  current_balance       :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class DeductionPayment < ActiveRecord::Base
  belongs_to :deduction_employee
  attr_accessible :current_balance, :payment, :payment_date, :previous_balance, :deduction_employee_id
end
