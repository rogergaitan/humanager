# == Schema Information
#
# Table name: other_salary_payments
#
#  id                       :integer          not null, primary key
#  other_salary_employee_id :integer
#  payment_date             :date
#  payment                  :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'test_helper'

class OtherSalaryPaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
