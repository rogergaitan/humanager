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

require 'test_helper'

class DeductionPayrollTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
