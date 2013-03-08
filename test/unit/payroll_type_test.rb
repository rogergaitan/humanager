# == Schema Information
#
# Table name: payroll_types
#
#  id           :integer          not null, primary key
#  description  :string(255)
#  payroll_type :enum([:Administr
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class PayrollTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
