# == Schema Information
#
# Table name: employee_benefits
#
#  id              :integer          not null, primary key
#  work_benefit_id :integer
#  employee_id     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class EmployeeBenefitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
