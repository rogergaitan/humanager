# == Schema Information
#
# Table name: cost_centers
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  description :string(255)
#  employee_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class CostCenterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
