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

require 'test_helper'

class DeductionPaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
