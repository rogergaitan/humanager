# == Schema Information
#
# Table name: payrolls
#
#  id              :integer          not null, primary key
#  payroll_type_id :integer
#  start_date      :date
#  end_date        :date
#  payment_date    :date
#  state           :boolean          default(TRUE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class PayrollTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
