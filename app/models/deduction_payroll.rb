# == Schema Information
#
# Table name: deduction_payrolls
#
#  id           :integer          not null, primary key
#  deduction_id :integer
#  payroll_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class DeductionPayroll < ActiveRecord::Base
  belongs_to :deduction
  belongs_to :payroll
  attr_accessible :deduction_id, :payroll_id
end
