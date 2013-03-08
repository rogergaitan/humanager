# == Schema Information
#
# Table name: payroll_employees
#
#  id             :integer          not null, primary key
#  employee_id    :integer
#  payroll_log_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class PayrollEmployee < ActiveRecord::Base
  belongs_to :employee
  belongs_to :payroll_log
  attr_accessible :employee_id, :payroll_log_id
end
