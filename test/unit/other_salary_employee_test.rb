# == Schema Information
#
# Table name: other_salary_employees
#
#  id              :integer          not null, primary key
#  other_salary_id :integer
#  employee_id     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  amount          :decimal(18, 2)
#

require 'test_helper'

class OtherSalaryEmployeeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
