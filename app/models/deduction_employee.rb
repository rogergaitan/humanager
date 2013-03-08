# == Schema Information
#
# Table name: deduction_employees
#
#  id              :integer          not null, primary key
#  deduction_id    :integer
#  employee_id     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  current_balance :integer
#

class DeductionEmployee < ActiveRecord::Base
  belongs_to :deduction
  belongs_to :employee
  has_many :deduction_payments, :dependent => :destroy
  attr_accessible :deduction_id, :employee_id, :current_balance
end
