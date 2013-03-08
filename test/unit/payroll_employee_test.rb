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

require 'test_helper'

class PayrollEmployeeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
