# == Schema Information
#
# Table name: payroll_logs
#
#  id           :integer          not null, primary key
#  payroll_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  payroll_date :date
#

require 'test_helper'

class PayrollLogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
