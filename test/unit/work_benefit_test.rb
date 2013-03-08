# == Schema Information
#
# Table name: work_benefits
#
#  id             :integer          not null, primary key
#  description    :string(255)
#  percentage     :decimal(12, 2)
#  debit_account  :integer
#  credit_account :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class WorkBenefitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
