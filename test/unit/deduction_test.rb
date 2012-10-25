# == Schema Information
#
# Table name: deductions
#
#  id                 :integer          not null, primary key
#  description        :string(255)
#  employee_id        :integer
#  frequency          :string(255)
#  calculation_method :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class DeductionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
