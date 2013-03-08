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

require 'test_helper'

class DeductionEmployeeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
